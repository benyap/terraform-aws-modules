#######################
# Configuration
#######################

module "site-bucket" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//s3-site-bucket"

  aws_region                       = var.aws_region
  bucket_name                      = "${var.domain_env_prefix}${var.domain_name}"
  index_document                   = var.index_document
  error_document                   = var.error_document
  routing_rules                    = var.routing_rules
  duplicate_content_penalty_secret = var.secret

  project_tag     = var.domain_name
  environment_tag = var.environment_tag
  type_tag        = "s3_bucket"
}

module "site-cert" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//acm-cert-dns-validation"

  account_id     = var.account_id
  role_name      = var.terraform_role_name
  domain_name    = "${var.domain_env_prefix}${var.domain_name}"
  hosted_zone_id = var.hosted_zone_id

  project_tag     = var.domain_name
  environment_tag = var.environment_tag
  type_tag        = "cert"
}

resource "aws_s3_bucket" "site-cdn-logging-bucket" {
  bucket = "${var.domain_env_prefix}${var.domain_name}.s3.amazonaws.com"
  region = var.aws_region
  acl    = "log-delivery-write"

  lifecycle_rule {
    id      = "log-rule"
    enabled = true
    prefix  = "log-${var.domain_env_prefix}${var.domain_name}/"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "ONEZONE_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
  tags {
    Project     = var.domain_name
    Environment = var.environment_tag
    Name        = "${var.domain_name}-${var.environment_tag}-cdn_logging_s3_bucket"
  }
}

module "site-cdn" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//cloudfront-distribution"

  origin_id                        = module.site-bucket.bucket_id
  website_endpoint                 = module.site-bucket.website_endpoint
  duplicate_content_penalty_secret = var.secret
  certificate_arn                  = module.site-cert.certificate_arn
  domain_aliases = [
    "${var.domain_env_prefix}${var.domain_name}"
  ]
  index_document = var.index_document
  error_document = var.error_document

  logging_enabled = true
  logging_bucket  = aws_s3_bucket.site-cdn-logging-bucket.id
  logging_prefix  = "log-${var.domain_env_prefix}${var.domain_name}/"

  project_tag     = var.domain_name
  environment_tag = var.environment_tag
  type_tag        = "cdn"
}

module "site-a-record" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//route53-alias-record"

  record_zone_id  = var.hosted_zone_id
  domain_name     = "${var.domain_env_prefix}${var.domain_name}"
  cdn_zone_id     = module.site-cdn.hosted_zone_id
  cdn_domain_name = module.site-cdn.cdn_domain_name
}
