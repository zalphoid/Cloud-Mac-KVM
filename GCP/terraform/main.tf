provider "google" {
  credentials = "${var.credentials}"
  region      = "${var.region}"
  project     = "${var.gcp_project}"
  zone        = "${var.zone}"
}

terraform {
  required_version = "0.12.31"

  required_providers {
    google = "~>2.20.2"
  }
}
