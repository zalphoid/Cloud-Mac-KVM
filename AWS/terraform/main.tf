provider "aws" {
  region  = "${var.region}"
  version = "${var.version}"
}

terraform {
  required_version = "0.11.12"
}
