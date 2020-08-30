# SES mail service user

_Terraform version: `v0.13.x`_

This module sets creates a service user with the appropriate permissions to send emails from SES.

**NOTE**: You will need to use the AWS console to manually create access keys for this user. By default, the created service user will have no access credentials.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-mail-service-user"

  user_name      = var.user_name
  account_id     = var.account_id
  email_domian   = var.email_domain
}
```

## Required variables

- `user_name`: The name of the service user to create (automatically prefixed by 's3site.deployer.').

- `account_id`: The account ID of the SES domain to send from.

- `email_domain`: The domain to send emails from.

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
