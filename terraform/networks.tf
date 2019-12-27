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

resource "google_compute_firewall" "firewall-myip" {
  name       = "${var.name}-firewall-myip"
  network    = "${var.name}-network"
  depends_on = ["google_compute_network.network"]

  allow {
    protocol = "tcp"
    ports    = ["22", "5900"]
  }

  source_ranges = ["${chomp(data.http.myip.body)}/32"]

  priority = 1000
}

resource "google_compute_firewall" "firewall-deny" {
  name       = "${var.name}-firewall-deny"
  network    = "${var.name}-network"
  depends_on = ["google_compute_network.network"]

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 1001
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
