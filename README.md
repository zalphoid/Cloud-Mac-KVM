# Cloud Mac KVM
Terraform code to help stand up a MacOS KVM on cloud hosting services. As of RC 0.1.0 The only cloud that is supported is GCP but others are coming.

### How to use

  1. Create account with hosting service.
  - [GCP](https://cloud.google.com)

  2. Setup environment.
  - [GCP Setup README](GCP/README.md#setting-up-a-gcp-environment)

  3. Download [Terraform CLI v0.11.12](https://releases.hashicorp.co://releases.hashicorp.com/terraform/0.11.12/) and install.

  3. Download or `git clone` this repo and `cd` into the hosting provider directory (at this time `GCP` is the only host), then into the `terraform` directory and create a file called `terraform.tfvars` then populate as seen [here](GCP/README.md#example-terraform.tfvars).

  4. Run `terraform init` to download the host provider.

  5. Input necessary variables to `terraform.tvars` file

  6. Run `terraform appy`

## Once Started

### VNC

The server will take aproximately 8 minutes to boot everything and install everythin for the first time. Once it is complete you can use a VNC client like TigerVNC to connect to it via the IP of the instance from the end of the terraform run. The VNC service is hosted on port 5900 and the firwall is locked to only your external IP. If you change network connections you will likely not have access to it. This is for security reasons as VNC isnt the most secure protocol.

## OpenCore Language

The OpenCore image from the source OSX-KVM repo is Japanese so you will need to change the langue after startup. To do this its the first menubar item, and first selection in that menu as seen in the image below:

[Change Language](language.png)


### Saving Mac for later

  - [GCP](GCP/README.md#saving-mac-for-later)
