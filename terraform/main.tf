provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "compute-api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = true
}

resource "google_compute_network" "vpc-network" {
  depends_on              = [google_project_service.compute-api]
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
  depends_on = [google_project_service.compute-api]
  name       = "ipv4-static-a"
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