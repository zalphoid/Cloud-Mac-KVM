# Setting up a GCP environment

Once a GCP account is created, next step is to setup a project and create the service account for that project.

1. Creating a project is pretty simple. [Here](https://cloud.google.com/appengine/docs/standard/nodejs/building-app/creating-project) are instructions for creating the project.

2. Creating a service account for your project. [Here](https://support.google.com/cloud/answer/6158849#serviceaccounts) are instructions for creating a service account

# Saving Mac for Later

 1. Remove image and disk from state list
 - `terraform state rm google_compute_image.macoskvm`
 - `terraform state rm google_compute_disk.disk`

 2. Destroy the rest of the resources
 - `terraform destroy`

 3. Import image and disk to state file
 - `terraform import google_compute_image.macoskvm macoskvm`
 - `terraform import google_compute_disk.disk disk`

# Example terraform.tfvars

```
region = "us-west2"
gcp_project = "cloudmac-262823"
credentials = "path to json service account creds"
name = "jcampbell"
zone = "us-west2-a"
ssh_key = "path to ssh key"
network_name = "macOSnet"
```
