resource "google_compute_network" "network" {
  name                    = "${var.name}-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  network       = "${var.name}-network"
  depends_on    = ["google_compute_network.network"]
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_firewall" "firewall" {
  name       = "${var.name}-firewall"
  network    = "${var.name}-network"
  depends_on = ["google_compute_network.network"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
