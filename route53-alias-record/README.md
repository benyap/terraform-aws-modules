# Route53 Alias Record

This module creates an Alias record on Route53 that points to a Cloudfront distribution.
This module requires that you have provisioned a Cloudfront distribution.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//route53-alias-record"

  record_zone_id  = "${var.record_zone_id}"
  cdn_zone_id     = "${var.cdn_zone_id}"
  domain_name     = "${var.domain_name}"
  cdn_domain_name = "${var.cdn_domain_name}"
}
```

## Required variables

- `record_zone_id`: The ID of the hosted zone in which the domain record is in.

- `cdn_zone_id`: The ID of the hosted zone where the CloudFront distribution is in.

- `domain_name`: The name of the domain for this record.

- `cdn_domain_name`: The domain for the CloudFront distribution this record should point to.


## Outputs

- `record_name`: The name of the record.

- `fqdn`: The fully qualified domain name built using the zone domain and name.


## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["route53:*"],
      "Resource": ["*"]
    }
  ]
}
```
