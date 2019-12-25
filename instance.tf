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
    user-data = "${file("script.sh")}"
  }

  service_account {
    scopes = ["compute-ro", "storage-ro"]
  }

  enable_display = "true"

  #  provisioner "remote-exec" {
  #    script = "script.sh"
  #
  #    connection {
  #      type        = "ssh"
  #      user        = "${var.name}"
  #      timeout     = "2m"
  #      private_key = "${file("/Users/jcampbell/.ssh/google_compute_engine.pub")}"
  #    }
  #  }
}
