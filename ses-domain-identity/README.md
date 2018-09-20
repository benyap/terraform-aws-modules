# SES domain identity

This module sets up a domain identity for SES and verifies it on Route53. Note that this module will create a provider in the region `us-east-1`.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-domain-identity"

  account_id        = "${var.account_id}"
  role_name         = "${var.role_name}"
  email_domain      = "${var.email_domain}"
  hosted_zone_id    = "${var.hosted_zone_id}"
}
```

## Required variables

- `account_id`: The account ID.

- `role_name`: The name of the role to assume to create the SES domain identity.

- `email_domain`: The custom email domain to use for SES.

- `hosted_zone_id`: The id of the hosted zone the domain was registered in.


## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:*",
        "ses:*"
      ],
      "Resource": ["*"]
    }
  ]
}
```
