terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "google" {
    credentials = file(var.credentialfile)

    project = var.projectid
    region = var.region
    zone = var.zone
}

provider "kubernetes" {  
  host = "https://${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token = data.google_client_config.provider.access_token
}

data "google_client_config" "provider" {}