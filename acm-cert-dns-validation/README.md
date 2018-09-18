# S3 Site bucket

This module provisions an SSL certificate for a domain record and validates it using DNS validation records.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//acm-cert-dns-validatation"

  account_id      = "${var.account_id}"
  role_name       = "${var.role_name}"
  domain_name     = "${var.domain_name}"
  hosted_zone_id  = "${var.hosted_zone_id}"

  project_tag     = "${var.project_tag}"
  environment_tag = "${var.environment_tag}"
  domain_tag      = "${var.domain_tag}"
}
```

## Required variables

- `account_id`: The id of the AWS account that owns the record.

- `role_name`: The role that will be used to provision the ACM certificate.

- `domain_name`: The name of the domain for this ACM certificate.

- `hosted_zone_id`: The ID of the hosted zone in which the domain's Route53 record is in.


## Optional variables

- `tags`: (OPTIONAL) A map of tags to add to the S3 bucket.


## Outputs

- `certificate_arn`: The ARN of the certificate.

- `name_tag`: The value of the 'Name' tag, constructed from the project, environment and domain.


## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["acm:*"],
      "Resource": ["*"]
    }
  ]
}
```