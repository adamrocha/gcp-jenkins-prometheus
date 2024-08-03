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
  name = "vpc-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_address" "static-a" {
  name = "ipv4-address-a"
}

resource "google_compute_address" "static-b" {
  name = "ipv4-address-b"
}

resource "google_compute_address" "static-c" {
  name = "ipv4-address-c"
}

resource "google_compute_instance" "vm-instance-a" {
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
      nat_ip = google_compute_address.static-a.address
    }
  }
}

resource "google_compute_instance" "vm-instance-b" {
  name         = "terraform-instance-b"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc-network.id
    access_config {
      nat_ip = google_compute_address.static-b.address
    }
  }
}

resource "google_compute_instance" "vm-instance-c" {
  name         = "terraform-instance-c"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc-network.id
    access_config {
      nat_ip = google_compute_address.static-c.address
    }
  }
}