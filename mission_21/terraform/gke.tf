resource "google_container_cluster" "primary" {
  name     = "lbg-gke"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.lbg_leaders_vpc_network.name
  subnetwork = google_compute_subnetwork.default.name
}

resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.projectid
    }
        
    machine_type = "e2-medium"
    disk_size_gb = 10
    tags         = ["gke-node", "${var.projectid}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
    
  autoscaling {
    total_max_node_count = var.maxnodecount
    total_min_node_count = var.minnodecount
  }
}

resource "kubernetes_namespace" "lbg-trainer" {
  metadata {
    name = "lbg-trainer"
  }
}

resource "kubernetes_namespace" "lbg" {
  count = var.delegatecount 
  metadata {
    name = "lbg-${count.index + 1}"
  }
}