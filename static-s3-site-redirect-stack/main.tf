#######################
# Configuration
#######################

module "site-redirect-bucket" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//s3-site-redirect-bucket"

  aws_region        = "${var.aws_region}"
  bucket_name       = "${var.domain_env_prefix}${var.domain_name}"
  redirect_target   = "${var.redirect_target}"
  redirect_protocol = "https"
  duplicate_content_penalty_secret = "${var.secret}"

  project_tag     = "${var.domain_name}"
  environment_tag = "${var.environment_tag}"
  type_tag        = "s3_redirect_bucket"
}

module "site-cert" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//acm-cert-dns-validation"

  account_id      = "${var.account_id}"
  role_name       = "${var.terraform_role_name}"
  domain_name     = "${var.domain_env_prefix}${var.domain_name}"
  hosted_zone_id  = "${var.hosted_zone_id}"

  project_tag     = "${var.domain_name}"
  environment_tag = "${var.environment_tag}"
  type_tag        = "cert"
}

module "site-cdn" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//cloudfront-distribution"

  bucket_id           = "${module.site-redirect-bucket.bucket_id}"
  website_endpoint    = "${module.site-redirect-bucket.website_endpoint}"
  certificate_arn     = "${module.site-cert.certificate_arn}"
  index_document      = ""
  error_document      = ""
  domain_alias        = "${var.domain_env_prefix}${var.domain_name}"
  duplicate_content_penalty_secret = "${var.secret}"

  project_tag     = "${var.domain_name}"
  environment_tag = "${var.environment_tag}"
  type_tag        = "cdn"
}

module "site-a-record" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//route53-alias-record"

  record_zone_id  = "${var.hosted_zone_id}"
  domain_name     = "${var.domain_env_prefix}${var.domain_name}"
  cdn_zone_id     = "${module.site-cdn.hosted_zone_id}"
  cdn_domain_name = "${module.site-cdn.cdn_domain_name}"
}
