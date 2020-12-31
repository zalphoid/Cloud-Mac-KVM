# AWS

## Steps to setup macOS in AWS

1. Set up your AWS environment
2. Define variables
  - set `instance_count` to 1
  - set `create_bucket` to false
  - set `users` list to `["user"]`
  - set `vnc_password` list to your desired password (same format as user list e.g. `["password"]`
3. Start the instance, connect to it, format the QEMU drive, install macOS (stop before the first reboot if you want to have multiple users as that will be your base image).
4. Set the `create_bucket` variable to `true` and set the variable `bucket` to a unique name.
5. SSH into the instance, rename the base image (located at the root directory `/user.img` to `/base.img` and upload the base image to your bucket with the `gsutil` command.
6. Set the variable `base_image` to `base.img`.
7. Set the username and password lists as needed.
8. Set `instance_count` to the desired number of instances.
9. PROFIT (but don't actually because this is legally questionable and should not be performed as this is just novelty code)


### Setting up a AWS environment

Once a AWS account is created, next step is to setup a project and create the service account for that project.

1. Creating a project is pretty simple. [Here](https://cloud.google.com/appengine/docs/standard/nodejs/building-app/creating-project) are instructions for creating the project.

2. Creating a service account for your project. [Here](https://support.google.com/cloud/answer/6158849#serviceaccounts) are instructions for creating a service account


### Instance Count

The terraform variable `instance_count` allows for users to easily deploy multiple KVM instances.

The variable `users` then assigns each index of the user to the indexed instance. (e.g. instance-1 == user1)


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

If you want to use the bucket to distribute a base image to the instances then make sure the variable `create_bucket` is set to true. This will create the resource and allow you to upload the base image to the bucket using the `gsutil` tool from the Google-Cloud-SDK. also be done after the initial creation and you can then upload the completed base image to your bucket then. Just change the variable and run an apply again.

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
