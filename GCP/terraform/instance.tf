resource "google_compute_instance" "kvm-host" {
  count        = "${var.instance_count}"
  name         = "kvm-host-${count.index + 1}"
  zone         = "${var.zone}"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "${element(google_compute_image.macoskvm.*.self_link, count.index)}"
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

resource "google_compute_image" "macoskvm" {
  count       = "${var.instance_count}"
  name        = "macoskvm-${count.index + 1}"
  source_disk = "${element(google_compute_disk.disk.*.self_link, count.index)}"

  licenses = [
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx",
  ]
}

resource "google_compute_disk" "disk" {
  count = "${var.instance_count}"
  name  = "disk"
  type  = "pd-ssd"
  zone  = "${var.zone}"
  image = "${var.source_image}"
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
