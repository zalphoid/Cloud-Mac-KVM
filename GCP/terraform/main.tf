provider "google" {
  credentials = "${var.credentials}"
  region      = "${var.region}"
  project     = "${var.gcp_project}"
  zone        = "${var.zone}"
}

terraform {
  required_vesrion = "0.11.12"

  required_providers {
    google = "~>2.20.2"
  }
}
