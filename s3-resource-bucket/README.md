# S3 resource bucket

This module creates and configures an S3 bucket that can be accessed using an IAM user.
This is useful for provisioning a storage bucket that can be accessed via a backend.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//s3-resource-bucket"

  aws_region      = "${var.aws_region}"
  bucket_name     = "${var.bucket_name}"

  project_tag     = "${var.project_tag}"
  environment_tag = "${var.environment_tag}"
}
```


## Required variables

- `aws_region`: The AWS region the website bucket will reside in.

- `bucket_name`: The name of the bucket to create.

- `project_tag`: The value for tag 'Project'.

- `environment_tag`: The value for tag 'Environment'.


## Optional variables

- `tags`: (OPTIONAL) A map of tags to add to the S3 bucket.


## Outputs

- `bucket_id`: The name of the bucket.

- `bucket_arn`: The ARN of the bucket.

- `name_tag`: The value of the 'Name' tag, constructed from the project, environment and domain.


## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetUser",
        "iam:CreateUser",
        "iam:DeleteUser",
        "iam:UpdateUser",
        "iam:GetUserPolicy",
        "iam:PutUserPolicy",
        "iam:DeleteUserPolicy",
        "iam:ListGroupsForUser",
        "iam:ListAccessKeys",
        "iam:DeleteAccessKey",
        "iam:ListMFADevices",
        "iam:DeleteLoginProfile"
      ],
      "Resource": ["*"]
    }
  ]
}
```
