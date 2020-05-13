resource "google_storage_bucket" "images" {
  name          = "${var.bucket}"
  location      = "${var.county_code}"
  force_destroy = false
}
