# S3 Site rediret bucket

This module creates and configures an S3 bucket for redirection.

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//s3site-redirect-bucket"

  aws_region        = "${var.aws_region}"
  bucket_name       = "${var.bucket_name}"
  redirect_target   = "${var.redirect_target}"
  redirect_protocol = "https"
  duplicate_content_penalty_secret = "${var.content_secret}"

  project_tag     = "${var.project_tag}"
  environment_tag = "${var.environment_tag}"
  type_tag        = "${var.type_tag}"
}
```

## Required variables

- `aws_region`: The AWS region the website bucket will reside in.

- `bucket_name`: The name of the bucket that holds the website assets.

- `duplicate_content_penalty_secret`: Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket.

- `redirect_target`: The target URL to redirect to.

- `redirect_protocol`: The protocol to use for the redirect URL (default to HTTPS).

- `project_tag`: The value for tag 'Project'.

- `environment_tag`: The value for tag 'Environment'.

- `type_tag`: The value for tag 'Type'.


## Optional variables

- `tags`: (OPTIONAL) A map of tags to add to the S3 bucket.


## Outputs

- `bucket_id`: The name of the bucket.

- `bucket_arn`: The ARN of the bucket.

- `bucket_hosted_zone_id`: The Route 53 Hosted Zone ID for this bucket's region.

- `website_endpoint`: The website endpoint.

- `website_domain`: The domain of the website endpoint.

- `name_tag`: The value of the 'Name' tag, constructed from the project, environment and domain.


## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": ["*"]
    }
  ]
}
```
