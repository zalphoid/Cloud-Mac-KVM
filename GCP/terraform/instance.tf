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
    user-data = "${data.template_file.script.rendered}"
  }

  service_account {
    scopes = ["compute-ro", "storage-rw"]
  }
}

data "template_file" "script" {
  template = "${file("scripts/init.sh")}"

  vars {
    PASSWORD   = "${var.vnc_password}"
    BUCKET     = "${var.bucket}"
    BASE_IMAGE = "${var.base_image}"
    SKIP_USER  = "${var.skip_user}"
  }
}
