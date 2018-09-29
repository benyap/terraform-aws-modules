# S3 Site service user

This module sets creates a service user with the appropriate permissions for deploying to an S3 site.

**NOTE**: You will need to use the AWS console to manually create access keys for this user. By default, the created service user will have no access credentials.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//s3-site-service-user"

  user_name      = "${var.user_name}"
  bucket_name    = "${var.bucket_name}"
}
```

## Required variables

- `user_name`: The name of the service user to create (automatically prefixed by 's3site.deployer.').

- `bucket_name`: The name of the website bucket to give the service user access to.


## Outputs

- `arn`: The ARN of the user that was created.

- `name`: The name of the user that was created.


## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
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
        "iam:ListGroupsForUser"
      ],
      "Resource": ["*"]
    }
  ]
}
```
