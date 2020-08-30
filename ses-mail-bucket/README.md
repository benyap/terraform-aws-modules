# SES mail bucket

_Terraform version: `v0.13.x`_

This module creates an S3 bucket to store emails, configured with the appropriate access for SES and lifecycle rules for object management.

**Note that this module requires a provider in the region `us-east-1`.**

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-mail-bucket"

  providers = {
    aws = "aws.us-east-1-provider"
  }

  account_id    = var.account_id
  email_domain  = var.email_domain

  project_tag       = var.project_tag
  environment_tag   = var.environment_tag
}
```

## Required variables

- `account_id`: The account ID.

- `email_domain`: The domain of the email this lambda will forward from.

- `project_tag`: The value for tag 'Project'.

- `environment_tag`: The value for tag 'Environment'.

## Optional variables

- `type_tag`: (OPTIONAL) The value for tag 'Type' (default is "email_s3_bucket").

- `tags`: (OPTIONAL) A map of tags to add to the S3 bucket.

## Outputs

- `bucket_name`: The name of the bucket created.

- `name_tag`: The value of the 'Name' tag, constructed from the project, environment and type.

## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ses:*"],
      "Resource": ["*"]
    }
  ]
}
```
