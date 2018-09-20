# SES forwarder lambda

This module configures SES to receive emails on a custom domain, and creates an S3 bucket to store emails and a Lambda function to automatically forward incoming emails to an external email.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-forwarder-lambda"

  account_id    = "${var.account_id}"
  role_name     = "${var.role_name}"

  email_domain  = "${var.email_domain}"
  rule_name     = "${var.rule_name}"

  lambda_from_email       = "test@${var.domain_name}"
  lambda_subject_prefix   = "FWD: "
  lambda_forward_mapping  = "${jsonencode(map(
    "test@${var.domain_name}", "${var.forward_email}"
  ))}"

  rule_set_name       = "${var.rule_set_name}"
  rule_set_recipients = ["test@${var.domain_name}"]

  project_tag       = "${var.project_tag}"
  environment_tag   = "${var.environment_tag}"
  type_tag          = "${var.type_tag}"
}
```

## Required variables

- `account_id`: The account ID.

- `role_name`: The name of the role to assume to maange SES resources.

- `email_domain`: The domain of the email this lambda will forward from.

- `rule_name`: A unique name for the resources created by this rule.

- `lambda_from_email`: Forwarded emails will come from this verified address.

- `lambda_forward_mapping`: JSON string of object where the key is the lowercase email address from which to forward and the value is an array of email addresses to which to send the message.

- `rule_set_name`: The name of the rule set to create and add SES forwarding rules to.

- `rule_set_recipients`: The list of accepted recipients for the rule set.

- `project_tag`: The value for tag 'Project'.

- `environment_tag`: The value for tag 'Environment'.

- `type_tag`: The value for tag 'Type'.


## Optional variables

- `lambda_subject_prefix`: (OPTIONAL) Forwarded emails subject will contain this prefix (default is "").

- `after`: (OPTIONAL) The name of the rule to position this rule after (default is "").


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
        "lambda:*",
        "iam:ListInstanceProfilesForRole",
        "iam:GetRole",
        "iam:CreateRole",
        "iam:CreatePolicy",
        "iam:DeleteRole",
        "iam:PassRole",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:ListPolicyVersions",
        "iam:DeletePolicy",
        "iam:AttachRolePolicy",
        "iam:ListAttachedRolePolicies"
      ],
      "Resource": ["*"]
    }
  ]
}
```
