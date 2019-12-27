# Google Cloud Mac KVM

## This is a repository to stand up MacOS in KVM on GoogleCloud

### Pre Req's

* Using [Kholia's OSX-KVM Repo](https://github.com/kholia/OSX-KVM), fetch the OSX BaseSystem img using the python script `./fetch-macOS.py`
* Create the bucket to store the image in:`terraform apply -target=google_storage_bucket.baseimage`

* Using your gcloud account, upload the image to the bucket: `gsutil cp BaseSystem.img gs://baseimage/`

#### Once the bucket has been created and the baseimage has been uploaded you are ready to create your host instance and the init script will handle creating the MacOS VM

### Terraform

#### Working out of the Terraform directory, run `terraform plan` and if everything looks correct, `terraform apply`


## If you are interested in helping and want to contribute here is some information on the repo:

* Trunk Based Development
