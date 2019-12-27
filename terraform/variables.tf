variable "region" {}
variable "gcp_project" {}
variable "credentials" {}
variable "name" {}
variable "ssh_key" {}
variable "zone" {}

variable "machine_type" {
  default     = "n1-standard-8"
  description = "Other options list in size are, n1-standard-2, n1-stanard-(number of cpu cores [4,8,16,32])"
}

variable "source_image" {
  default = "ubuntu-1804-bionic-v20191211"
}

variable "network_name" {}

variable "disk_size" {
  default = "40"
}
