variable "instance_count" {
  description = "The number of instances you want to deploy"
  default = "1"
}

variable "region" {
  description = "The region this infrastructure will be created in"
}

variable "gcp_project" {
  description = "The Google Project created for this deployment"
}

variable "credentials" {
  description = "The credentials file. Helpful information can be found in the GCP README.md"
}

variable "name" {
  description = "Generic name of deployment"
}

variable "zone" {
  description = "Zone of the region the infrastructure will be created in"
}

variable "machine_type" {
  default     = "n1-standard-8"
  description = "Other options listed in size are, n1-standard-2, n1-stanard-(number of cpu cores [4,8,16,32])"
}

variable "source_image" {
  default = "ubuntu-1804-bionic-v20191211"
}

variable "disk_size" {
  description = "The size of the disk uses for the KVM-host instance. Must be larger than 40GB for macOS VM image"
  default     = "260"
}

variable "county_code" {
  default = "us"
}

variable "bucket" {
  description = "The name of the bucket created in GCP. Some bucket names are take (much like how usernames can be take."
}

variable "base_image" {
  default = "disk.img"
}

variable "vnc_password" {
  default = "password1"
}

variable "skip_user" {
  default = "false"
}
