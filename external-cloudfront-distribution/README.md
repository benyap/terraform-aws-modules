# External Cloudfront distribution

This module provisions a Cloudfront distribution that points to an external origin.
This module requires that you have provisioned an SSL certificate in ACM.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//external-cloudfront-distribution"

  origin_id           = "${var.origin_id}"
  website_endpoint    = "${var.website_endpoint}"
  certificate_arn     = "${var.certificate_arn}"
  domain_aliases      = [
    "${var.domain_alias}"
  ]
  custom_headers      = "${var.custom_headers}"
  index_document      = "${var.index_document}"
  error_document      = "${var.error_document}"

  logging_enabled     = true
  logging_bucket      = "${var.logging_bucket}"
  logging_prefix      = "${var.logging_prefix}"

  project_tag     = "${var.project_tag}"
  environment_tag = "${var.environment_tag}"
  type_tag        = "${var.type_tag}"
}
```

## Required variables

- `origin_id`: The name for the origin.

- `website_endpoint`: The endpoint URL for the distribution.

- `certificate_arn`: The id of an SSL certificate for this domain from AWS Certificate Manager.

- `project_tag`: The value for tag 'Project'.

- `environment_tag`: The value for tag 'Environment'.

- `type_tag`: The value for tag 'Type'.


## Optional variables

- `domain_aliases`: (OPTIONAL) Alternate domain names (CNAME) for this distribution (default is []).

- `index_document`: (OPTIONAL) The index document file name for the site (default is "").

- `error_document`: (OPTIONAL) The error document file name for the site (default is "").

- `logging_enabled`: (OPTIONAL) Set this to true to enable logging to an S3 bucket (default is false).

- `logging_bucket`: (OPTIONAL) The name of the S3 bucket to record logs in (default is "").

- `logging_prefix`: (OPTIONAL) The prefix to attach to logs in the logging bucket (default is "").

- `allowed_methods`: (OPTIONAL) The allowed methods for this distribution (default is all HTTP methods).

- `custom_headers`: (OPTIONAL) Custom headers to forward through Cloudfront.

- `forward_query_string`: (OPTIONAL) Forward the query string to the origin (default is false).

- `tags`: (OPTIONAL) A map of tags to add to the S3 bucket.


## Outputs

- `cdn_domain_name`: The domain name name to access the distribution.

- `hosted_zone_id`: The hosted zone ID of the region the distribution is in.

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
        "cloudfront:*",
        "acm:ListCertificates",
        "iam:ListServerCertificates",
        "waf:GetWebACL",
        "waf:ListWebACLs"
      ],
      "Resource": ["*"]
    }
  ]
}
```
