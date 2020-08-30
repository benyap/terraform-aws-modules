# S3 static site stack

_Terraform version: `v0.13.x`_

This module provisions the following resources to host a static site using a custom domain:

- S3 bucket with static site hosting

- SSL certificate for your custom domain

- Cloudfront distribution that points to S3 static site

- Route53 A record to direct your custom domain to the Cloudfront distribution

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//static-s3-site-stack"

  aws_region          = var.aws_region
  account_id          = var.account_id
  terraform_role_name = var.terraform_role_name

  domain_name       = var.domain_name
  domain_env_prefix = var.domain_env_prefix
  environment_tag   = var.environment_tag
  hosted_zone_id    = var.hosted_zone_id
  index_document    = var.index_document
  error_document    = var.error_document
  routing_rules     = var.routing_rules
  secret            = var.secret
}
```

**NOTE**: Sometimes, the SSL certificate does not finish validating before the Cloudfront distribution is created, causing Terraform to abort with the following error:

```
error creating CloudFront Distribution: InvalidViewerCertificate: The specified SSL certificate doesn't exist, isn't in us-east-1 region, isn't valid, or doesn't include a valid certificate chain.
```

To resolve this issue, simply run `terraform apply` again.

## Required variables

- `aws_region`: The name of the AWS region.

- `account_id`: The account ID.

- `terraform_role_name`: The name of the role for Terraform to use.

- `domain_name`: The name of the domain to create.

- `environment_tag`: The value for tag 'Environment'.

- `hosted_zone_id`: The ID of the hosted zone in which the domain record is in.

- `index_document`: The name of the index file for the website.

- `error_document`: The name of the error file for the website.

- `secret`: Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket.

## Optional variables

- `domain_env_prefix`: The domain prefix to the root domain.

- `routing_rules`: Routing rules for the S3 website.

## Outputs

- `bucket_id`: The name of the bucket that holds the static site content.

- `bucket_arn`: The ARN of the bucket that holds the static site content.

- `bucket_hosted_zone_id`: The Route 53 Hosted Zone ID for this bucket's region.

- `website_endpoint`: The S3 static site endpoint URL.

- `certificate_arn`: The ARN of the certificate assigned to the Cloudfront distribution.

- `cdn_domain_name`: The domain name of the Cloudfront distribution.

## Pre-requisites

To apply or destroy this configuration, you require the permissions from the following configurations:

- [s3-site-bucket](https://github.com/bwyap/terraform-aws-modules/tree/master/s3-site-bucket)

- [acm-cert-cdn-validation](https://github.com/bwyap/terraform-aws-modules/tree/master/acm-cert-cdn-validation)

- [cloudfront-distribution](https://github.com/bwyap/terraform-aws-modules/tree/master/cloudfront-distribution)

- [route53-alias-record](https://github.com/bwyap/terraform-aws-modules/tree/master/route53-alias-record)
