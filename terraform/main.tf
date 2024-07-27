# Define Terrraform Backend and Providers
terraform {
  required_version = "> 1.5"

  required_providers {
    google = {
      version = "~> 5.0.0"
    }
  }
}

provider "google" {
  project = "prometheus-430617"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}