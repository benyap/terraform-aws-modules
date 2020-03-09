# External site stack

_Terraform version: `v0.12.x`_

This module provisions the following resources to route to an external origin using a custom domain:

- SSL certificate for your custom domain

- Cloudfront distribution that points to an external origin

- Route53 A record to direct your custom domain to the Cloudfront distribution

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//external-site-stack"

  aws_region          = var.aws_region
  account_id          = var.account_id
  terraform_role_name = var.terraform_role_name

  domain_name           = var.domain_name
  domain_env_prefix     = var.domain_env_prefix
  external_site_origin  = var.external_site_origin
  origin_path           = var.origin_path
  environment_tag       = var.environment_tag
  hosted_zone_id        = var.hosted_zone_id
  index_document        = var.index_document
  error_document        = var.error_document
  forwarded_headers   = [
    var.forwarded_header_value_or_pattern
  ]
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

- `external_site_origin`: The DNS domain name of the external site to point to.

- `environment_tag`: The value for tag 'Environment'.

- `hosted_zone_id`: The ID of the hosted zone in which the domain record is in.

- `index_document`: The name of the index file for the website.

- `error_document`: The name of the error file for the website.

## Optional variables

- `origin_path`: (OPTIONAL) A path for CloudFront to request your content from within your S3 bucket or your custom origin.

- `domain_env_prefix`: (OPTIONAL) The domain prefix to the root domain.

- `forwarded_headers`: (OPTIONAL) Headers for Cloudfront to forward from the host request (defualt is []).

## Pre-requisites

To apply or destroy this configuration, you require the permissions from the following configurations:

- [acm-cert-cdn-validation](https://github.com/bwyap/terraform-aws-modules/tree/master/acm-cert-cdn-validation)

- [external-cloudfront-distribution](https://github.com/bwyap/terraform-aws-modules/tree/master/external-cloudfront-distribution)

- [route53-alias-record](https://github.com/bwyap/terraform-aws-modules/tree/master/route53-alias-record)
