# Terraform set up

_Terraform version: `v0.13.x`_

This module sets up the scaffolding for Terraform to be able to manage your infrastructure using good AWS IAM practices. This module should be run **ONCE** using an IAM user with full administrator access, which can be deleted afterwards.

This module creates the following:

- An S3 bucket which Terraform can use to store its state

- An IAM role for Terraform to assume (by default, only permission to access the S3 state bucket is given)

- A group for IAM users that Terraform can use, giving it access to the S3 state bucket and permission to switch to the Terraform role

To use this module in your configuration, use this repository subdirectory as a source:

```hcl
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//terraform-setup"

  aws_region            = var.aws_region
  account_id            = var.account_id
  backend_bucket_name   = var.backend_bucket_name
  terraform_role_name   = var.terraform_role_name
  terraform_group_name  = var.terraform_group_name
}
```

## Variables required in `terraform.tfvars`

- `aws_region`: The region the AWS resources will be created in

- `account_id`: The account ID for the root AWS account

- `backend_bucket_name`: The name of the bucket to store the Terraform state in

- `terraform_role_name`: (OPTIONAL) The name of the Terraform role

- `terraform_group_name`: (OPTIONAL) The name of the group for Terraform users

## Outputs

- `terraform_role_arn`

- `terraform_role_name`

- `terraform_role_unique_id`

- `terraform_role_description`

- `terraform_role_create_date`

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
