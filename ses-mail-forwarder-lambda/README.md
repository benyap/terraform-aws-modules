# SES mail forwarder lambda

_Terraform version: `v0.12.x`_

This module configures SES to receive emails on a custom domain and creats a Lambda function to automatically store emails in an **existing** S3 bucket and forward them to an external email.

You can use the [`ses-mail-bucket`](https://github.com/bwyap/terraform-aws-modules/tree/master/ses-mail-bucket) module to create an S3 bucket that is pre-configured for use by this module.

**Note that this module requires a provider in the region `us-east-1`.**

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-forwarder-lambda"

  providers = {
    aws = "aws.us-east-1-provider"
  }

  bucket_name   = "${var.bucket_name}"
  email_domain  = "${var.email_domain}"
  rule_name     = "${var.rule_name}"

  email_object_prefix     = "forwarded/"
  lambda_from_email       = "test@${var.domain_name}"
  lambda_subject_prefix   = "FWD: "
  lambda_forward_mapping  = "${jsonencode(map(
    "test@${var.domain_name}", "${var.forward_email}"
  ))}"

  rule_set_name       = "${var.rule_set_name}"
  rule_set_recipients = ["test@${var.domain_name}"]

  project_tag       = "${var.project_tag}"
  environment_tag   = "${var.environment_tag}"
}
```

## Required variables

- `bucket_name`: The name of the S3 bucekt to store emails in.

- `email_domain`: The domain of the email this lambda will forward from.

- `rule_name`: A unique name for the resources created by this rule.

- `lambda_from_email`: Forwarded emails will come from this verified address.

- `lambda_forward_mapping`: JSON string of object where the key is the lowercase email address from which to forward and the value is an array of email addresses to which to send the message.

- `rule_set_name`: The name of the rule set to create and add SES forwarding rules to.

- `rule_set_recipients`: The list of accepted recipients for the rule set.

- `project_tag`: The value for tag 'Project'.

- `environment_tag`: The value for tag 'Environment'.

## Optional variables

- `email_object_prefix`: (OPTIONAL) The prefix to add to the object name in S3 (default is "forwarded/").

- `lambda_subject_prefix`: (OPTIONAL) Forwarded emails subject will contain this prefix (default is "").

- `after`: (OPTIONAL) The name of the rule to position this rule after (default is "").

- `type_tag`: (OPTIONAL) The value for tag 'Type' (default is "fwd_lambda").

- `tags`: (OPTIONAL) A map of tags to add to the S3 bucket.

## Outputs

- `forwarder_rule_name`: The name of the forwarder rule that was created.

- `name_tag`: The value of the 'Name' tag, constructed from the project, environment and domain.

## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ses:*",
        "lambda:*",
        "iam:ListInstanceProfilesForRole",
        "iam:GetRole",
        "iam:CreateRole",
        "iam:CreatePolicy",
        "iam:CreatePolicyVersion",
        "iam:DeleteRole",
        "iam:PassRole",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:ListPolicyVersions",
        "iam:DeletePolicy",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:ListAttachedRolePolicies"
      ],
      "Resource": ["*"]
    }
  ]
}
```
