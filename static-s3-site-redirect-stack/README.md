# S3 static site redirect stack

_Terraform version: `v0.13.x`_

This module provisions the following resources to host a static site that redirects users via a custom domain:

- S3 bucket with static site hosting and redirection

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
  redirect_target   = var.redirect_target
  secret            = var.secret
}
```

## Required variables

- `aws_region`: The name of the AWS region.

- `account_id`: The account ID.

- `terraform_role_name`: The name of the role for Terraform to use.

- `domain_name`: The name of the domain to create.

- `environment_tag`: The value for tag 'Environment'.

- `hosted_zone_id`: The ID of the hosted zone in which the domain record is in.

- `redirect_target`: The target URL to redirect to.

- `secret`: Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket.

## Optional variables

- `domain_env_prefix`: The domain prefix to the root domain.

## Pre-requisites

To apply or destroy this configuration, you require the permissions from the following configurations:

- [s3-site-redirect-bucket](https://github.com/bwyap/terraform-aws-modules/tree/master/s3-site-redirect-bucket)

- [acm-cert-cdn-validation](https://github.com/bwyap/terraform-aws-modules/tree/master/acm-cert-cdn-validation)

- [cloudfront-distribution](https://github.com/bwyap/terraform-aws-modules/tree/master/cloudfront-distribution)

- [route53-alias-record](https://github.com/bwyap/terraform-aws-modules/tree/master/route53-alias-record)
