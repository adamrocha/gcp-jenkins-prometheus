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

resource "google_compute_network" "vpc-network" {
  name                    = "vpc-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "egress" {
  name      = "egress-firewall"
  network   = google_compute_network.vpc-network.name
  direction = "EGRESS"

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "ingress" {
  name          = "ingress-firewall"
  network       = google_compute_network.vpc-network.name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}

resource "google_compute_address" "ipv4-static-a" {
  name = "ipv4-static-a"
}

resource "google_compute_instance" "terraform-instance-a" {
  name         = "terraform-instance-a"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc-network.id
    access_config {
      nat_ip = google_compute_address.ipv4-static-a.address
    }
  }
}