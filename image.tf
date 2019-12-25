resource "google_compute_image" "macoskvm" {
  name        = "macoskvm"
  source_disk = "${google_compute_disk.disk.self_link}"

  licenses = [
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx",
  ]
}

resource "google_compute_disk" "disk" {
  name  = "disk"
  type  = "pd-ssd"
  zone  = "${var.zone}"
  image = "${var.source_image}"
}
