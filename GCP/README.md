# GCP

## Setting up a GCP environment

Once a GCP account is created, next step is to setup a project and create the service account for that project.

1. Creating a project is pretty simple. [Here](https://cloud.google.com/appengine/docs/standard/nodejs/building-app/creating-project) are instructions for creating the project.

2. Creating a service account for your project. [Here](https://support.google.com/cloud/answer/6158849#serviceaccounts) are instructions for creating a service account


## Instance Count

The terraform variable `instance_count` allows for users to easily deploy multiple KVM instances.

## Username

  If you plan to have images for each use of this KVM and save them in the bucket for later use then you will need to ssh into your instance via the instance IP or `gcloud compute ssh kvm-host`. Once connected to your instance, write a file with the name username containing the users name to the tmp directory like so: `echo "users-name" > /tmp/username`.

  This will finish the init script and either pull that users image or create a new users image if that users name doesn't exist in the bucket.

  If you want to skip this step, simply set the variable `SKIP_USER` to `true`.

  You can also choose to skip the user step to create your first base image. Once you have completed installing macOS to the main volume you can then upload the image, found at `/disk.img` to your bucket via the gsutil command - `gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp /disk.img gs://$BUCKET_NAME`.

## Saving Mac for Later

 1. Remove image and disk from state list
 - `terraform state rm google_compute_image.macoskvm`
 - `terraform state rm google_compute_disk.disk`

 2. Destroy the rest of the resources
 - `terraform destroy`

 3. Import image and disk to state file
 - `terraform import google_compute_image.macoskvm macoskvm`
 - `terraform import google_compute_disk.disk disk`

## Example terraform.tfvars

```
region = ""
zone = ""
name = ""
gcp_project = ""
credentials = ""
```

- region - (e.g. `us-west-2`) Other regions can be found [here](https://cloud.google.com/compute/docs/regions-zones/#locations)
- zone - (e.g. `us-west-2-a`) Zone can be found on the same page as region using the same format as seen in the example.
 - name - Generic name used in much of the infrastructure of this deployment.
- gcp_project - The full project name including the random string of numbers appended to the end of it (e.g. `maccloud-1235612`)
- credentials - The path to the credentials file you downloaded when setting up a service account (e.g. `/Users/macuser/.ssh/maccloud.json`)

## To bucket or not to bucket, that is the question

### Bucket ^.^

In the terraform directory there is a file called `bucket.tf`.

You have two options, use the bucket or don't use the bucket.

If you want to use the bucket to distribute a base image to the instances then you can first run a target apply for your Terraform. This will allow you to upload the base image to the bucket using the `gsutil` tool from the Google-Cloud-SDK.

`gsutil cp Macintoshhd.img gs://bucket-name-here/`

This requires the base image to have a name in the `variables.tf` file. The name corresponds to the full name of the file (e.g. `Macintoshhd.img`).

### NO BUCKET?!?!?!

That's fine too..

Just make sure to:
1. Delete `the bucket.tf` file from the terraform directory.
2. Set the variables `base_image` and `bucket` to `null`

The script will then run and download the BaseSystem.dmg via this [Fetch macOS python script](https://github.com/kholia/OSX-KVM/blob/master/fetch-macOS.py) and create a user image in the root directory of the kvm-host system.

## Debugging

I highly recommend that you watch the init script as it runs to make sure the instance starts the KVM. To do this you can:
- ssh into the instance `gcloud compute ssh kvm-host`
- assume super user permission `sudo -i`
- tail the log from cloud-init `tail -f /var/log/cloud-init-output.log`

This will then start to follow any appended data to the log file. If you want to view it in its entirety, run `view /var/log/cloud-init-output.log`.

If you are having issues with the init script you can find it at `/var/lib/cloud/instance/user-data.txt`.
