# terraform-aws-modules

A collection of modules for configuring and provisioning AWS resources through Terraform. For convenience.

_All modules require Terraform version `v0.12.x`_

## Modules

These configurations are designed to be used as modules within your own Terraform code.
Each module has its own README where you can find information about its inputs, outputs and required IAM permissions.

### Configuration

- [external-access](https://github.com/bwyap/terraform-aws-modules/tree/master/external-access) for setting up the external trust relationships for an AWS account

- [terraform-setup](https://github.com/bwyap/terraform-aws-modules/tree/master/terraform-setup) for setting up the scaffolding for Terraform to manage infrastructure using good AWS IAM practices

### Static site hosting

- [s3-site-bucket](https://github.com/bwyap/terraform-aws-modules/tree/master/s3-site-bucket) for creating S3 buckets with static site hosting

- [s3-site-service-user](https://github.com/bwyap/terraform-aws-modules/tree/master/s3-site-service-user) for creating IAM service users to deploy to S3 site buckets

- [acm-cert-cdn-validation](https://github.com/bwyap/terraform-aws-modules/tree/master/acm-cert-cdn-validation) for provisioning SSL certificates

- [cloudfront-distribution](https://github.com/bwyap/terraform-aws-modules/tree/master/cloudfront-distribution) for creating Cloudfront distributions (CDN)

- [route53-alias-record](https://github.com/bwyap/terraform-aws-modules/tree/master/route53-alias-record) for creating DNS records to a custom domain

- [static-s3-site-stack](https://github.com/bwyap/terraform-aws-modules/tree/master/static-s3-site-stack) for provisioning a stack of resources to serve a static site through a custom domain (using S3, Cloudfront and Route53)

- [static-s3-site-redirect-stack](https://github.com/bwyap/terraform-aws-modules/tree/master/static-s3-site-redirect-stack) for provisioning a stack of resources to serve a static site redirect through a custom domain (using S3, Cloudfront and Route53)

### External site hosting

- [external-cloudfront-distribution](https://github.com/bwyap/terraform-aws-modules/tree/master/external-cloudfront-distribution) for provisioning a Cloudfront distribution that points to an external origin

- [external-site-stack](https://github.com/bwyap/terraform-aws-modules/tree/master/external-site-stack) for provisioning a route that points to an external origin using a custom domain

### Custom email

- [ses-domain-identity](https://github.com/bwyap/terraform-aws-modules/tree/master/ses-domain-identity) for creating DNS and MX records in Route53 for a custom email domain

- [ses-service-user](https://github.com/bwyap/terraform-aws-modules/tree/master/ses-service-user) for creating IAM service users to send emails through SES

- [ses-mail-bucket](https://github.com/bwyap/terraform-aws-modules/tree/master/ses-mail-bucket) for creating a S3 bucket that is configured for storing emails from SES

- [ses-mail-forwarder-lambda-v2](https://github.com/bwyap/terraform-aws-modules/tree/master/ses-mail-forwarder-lambda-v2) for configuring SES
  to receive and automatically forwarding emails on a custom email domain

- [ses-mail-bouncer](https://github.com/bwyap/terraform-aws-modules/tree/master/ses-mail-bouncer) for configuring SES to bounce specified email addresses on a custom email domain

### Other utilities

- [s3-resource-bucket](https://github.com/bwyap/terraform-aws-modules/tree/master/s3-resource-bucket) for creating S3 buckets to store resources to be accessed by a backend

## Installation

You will need Terraform installed on your computer. Go to [terraform.io](https://www.terraform.io/) to download. Make sure the command `terraform` is available from the command line.

## How to run these configurations

Each of these configurations contain a `README.md` file in its root, where it will detail what the configuration does, and what pre-requisites are required.

If it is your first time running a configuration, you will need to do the following:

1. Set up the AWS credentials with the details of the IAM user Terraform will be using in the AWS credentials file at `~/.aws/credentials` like so:

```
[PROFILE_NAME]
aws_access_key_id=********************
aws_secret_access_key=****************************************
```

2. Switch to the profile by exporting the name of the profile to the variable AWS_PROFILE:

```bash
export AWS_PROFILE=PROFILE_NAME
```

3. Run `terraform init` in the root of the configuration to initialise Terraform and download modules and plugins.

Once you have completed all pre-requisites for a configuration, you can apply the configuration to your AWS infrastructure:

1. Run the command `terraform plan` to see how Terraform will change your infrastructure.

2. Run the command `terraform apply` to actually apply the configuration to your infrastructure.

3. If you ever need to destroy infrastructure created by Terraform, run `terraform destroy`.

For more information on how to use Terraform, go to the [documentation](https://www.terraform.io/intro/getting-started/install.html).
