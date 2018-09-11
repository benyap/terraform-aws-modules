# Terraform set up

This configuration sets up the scaffolding for Terraform to be able to manage your infrastructure using good AWS IAM practices. This configuration should be run **ONCE** using an IAM user with full administrator access, which can be deleted afterwards.

This configuration creates the following:

- An S3 bucket which Terraform can use to store its state

- An IAM role for Terraform to assume (by default, only permission to access the S3 state bucket is given)

- A group for IAM users that Terraform can use, giving it access to the S3 state bucket and permission to switch to the Terraform role


## Variables required in `terraform.tfvars`

- `aws_region`: The region the AWS resources will be created in

- `account_id`: The account ID fo the root AWS account

- `backend_bucket_name`: The name of the bucket to store the Terraform state in

- `terraform_role_name`: The name of the Terraform role

- `terraform_group_name`: The name of the group for Terraform users


## Pre-requisites

1. Create an IAM user with adminstrator access.
This use should only be used to set up the initial IAM settings and deleted afterwards.
Save the user's access key and secret to ~/.aws/credentials file under a profile like so:

```
[PROFILE_NAME]
aws_access_key_id=********************
aws_secret_access_key=****************************************
```

2. Set the `AWS_PROFILE` variable to use the profile from step 1.

```
export AWS_PROFILE=PROFILE_NAME
```

3. You are now ready to run this Terraform configuration.
