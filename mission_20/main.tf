terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("exec-cohort-X-newkey.json")

  project = "exec-cohort-4"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}

resource "google_compute_network" "lbg_exec_vpc_network" {
  name = "lbg-exec-targets-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "exec-custom-subnet"  
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"  
  network       = google_compute_network.lbg_exec_vpc_network.id
}

resource "google_compute_instance" "executive_vm" {
  count        = 9

  name         = "executive-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = "europe-west1-c"
  tags         = ["exec"]


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

metadata_startup_script ="sudo apt-get update && sudo apt-get upgrade -y; sudo apt-get install git -y; sudo apt-get install docker.io -y"

    network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
resource "google_compute_firewall" "exec-ssh" {
name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.lbg_exec_vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["exec"]
}
resource "google_compute_firewall" "apache" {
  name    = "apache-firewall"
  network = google_compute_network.lbg_exec_vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "mysql" {
  name    = "mysql-firewall"
  network = google_compute_network.lbg_exec_vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "java-spring" {
  name    = "java-spring-firewall"
  network = google_compute_network.lbg_exec_vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "cars-react" {
  name    = "cars-react-firewall"
  network = google_compute_network.lbg_exec_vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "vat-react" {
  name    = "vat-react-firewall"
  network = google_compute_network.lbg_exec_vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["3005"]
  }
  source_ranges = ["0.0.0.0/0"]
}
output "Targets-URLs" {
 value = join("",["http://",google_compute_instance.executive_vm[0].network_interface.0.access_config.0.nat_ip,":8080"])
}
output "IPs" {
  value = "${google_compute_instance.executive_vm[*].network_interface.0.access_config.0.nat_ip}"
}