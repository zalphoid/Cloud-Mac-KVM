resource "google_storage_bucket" "images" {
  count         = "${var.create_bucket ? 1 : 0}"
  name          = "${var.bucket}"
  location      = "${var.county_code}"
  force_destroy = false
}
