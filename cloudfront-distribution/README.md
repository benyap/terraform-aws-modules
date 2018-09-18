# Cloudfront distribution

This module provisions a Cloudfront distribution for a static S3 site.
This module requires that you have provisioned a static site on S3 and an SSL certificate in ACM.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//cloudfront-distribution"

  bucket_id           = "${var.bucket_name}"
  website_endpoint    = "${var.website_endpoint}"
  duplicate_content_penalty_secret = "${var.secret}"
  certificate_arn     = "${var.certificate_arn}"
  index_document      = "${var.index_document}"
  error_document      = "${var.error_document}"
  domain_alias        = "${var.domain_alias}"

  project_tag     = "${var.project_tag}"
  environment_tag = "${var.environment_tag}"
  domain_tag      = "${var.domain_tag}"
}
```

## Required variables

- `bucket_id`: The name of the S3 bucket the website is hosted on.

- `website_endpoint`: The endpoint URL for the S3 site.

- `duplicate_content_penalty_secret`: Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket.

- `certificate_arn`: The id of an SSL certificate for this domain from AWS Certificate Manager.

- `index_document`: The index document file name for the site.

- `error_document`: The error document file name for the site.

- `domain_alias`: Alternate domain name (CNAME) for this distribution.


## Optional variables

- `forward_query_string`: (OPTIONAL) Forward the query string to the origin. Default is false.

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
