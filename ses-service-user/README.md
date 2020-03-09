# SES service user

_Terraform version: `v0.12.x`_

This module creates a service user with the appropriate permissions to send emails through SES.

**NOTE**: You will need to use the AWS console to manually create access keys for this user. By default, the created service user will have no access credentials.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-service-user"

  account_id      = var.account_id
  ses_region      = var.ses_region
  domain_identity = var.domain_identity
  user_name       = var.user_name
}
```

## Required variables

- `account_id`: The account ID.

- `ses_region`: The region SES is configured in.

- `domain_identity`: The name of the domain through which emails are to be sent.

- `user_name`: The name of the service user to create (automatically prefixed by 'ses.emailer-').

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
