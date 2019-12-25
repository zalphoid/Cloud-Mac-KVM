variable "region" {}
variable "gcp_project" {}
variable "credentials" {}
variable "name" {}
variable "ssh_key" {}
variable "zone" {}
variable "machine_type" {}

variable "source_image" {
  default = "ubuntu-1804-bionic-v20191211"
}

variable "network_name" {}
