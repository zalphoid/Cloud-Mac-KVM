variable "instance_count" {
  description = "The number of instances you want to deploy"
  default     = "3"
}

variable "create_bucket" {
  description = "Creates the bucket for use storing the images"
  default     = false
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
  default     = "n1-standard-2"
  description = "Other options listed in size are, n1-standard-2, n1-stanard-(number of cpu cores [4,8,16,32])"
}

variable "source_image" {
  default = "ubuntu-1804-bionic-v20191211"
}

variable "disk_size" {
  description = "The size of the disk uses for the KVM-host instance. Must be larger than 40GB for macOS VM image"
  default     = "40"
}

variable "county_code" {
  default = "us"
}

variable "bucket" {
  description = "The name of the bucket created in GCP. Some bucket names are take (much like how usernames can be take."
}

variable "base_image" {
  default = "null"
}

variable "vnc_password" {
  type = "list"

  default = ["password1", "password2", "password3"]
}

variable "users" {
  description = "List of users (in order of instances being created) to use each instance."
  type        = "list"

  default = ["user1", "user2", "user3"]
}

variable "image_size" {
  description = "The size of the image that QEMU-IMG will create inside the instance"
  default     = "128G"
}
