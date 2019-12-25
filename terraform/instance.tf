resource "google_compute_instance" "kvm-host" {
  name         = "kvm-host"
  zone         = "${var.zone}"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "${google_compute_image.macoskvm.self_link}"
    }
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.subnet.self_link}"
    access_config = {}
  }

  metadata {
    user-data = "${file("scripts/init.sh")}"
  }

  service_account {
    scopes = ["compute-ro", "storage-ro"]
  }

  enable_display = "true"
}
