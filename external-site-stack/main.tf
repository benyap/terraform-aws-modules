#######################
# Configuration
#######################

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

module "site-cdn" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//external-cloudfront-distribution"

  origin_id       = "${replace(var.external_site_origin, ".", "-")}-origin"
  domain_name     = var.external_site_origin
  origin_path     = var.origin_path
  certificate_arn = module.site-cert.certificate_arn
  domain_aliases = [
    "${var.domain_env_prefix}${var.domain_name}"
  ]
  index_document    = var.index_document
  error_document    = var.error_document
  forwarded_headers = var.forwarded_headers

  logging_enabled = false

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
