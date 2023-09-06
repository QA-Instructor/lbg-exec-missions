resource "google_compute_network" "lbg_leaders_vpc_network" {
  name = "lbg-cohort-targets-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "cohort-custom-subnet"  
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region  
  network       = google_compute_network.lbg_leaders_vpc_network.id
}
