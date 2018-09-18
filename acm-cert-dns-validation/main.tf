#######################
# Setup
#######################

# Use an AWS provider in the us-east-1 region for ACM
provider "aws" {
  region  = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.role_name}"
  }
}


#######################
# Configuration
#######################

resource "aws_acm_certificate" "cert" {
  domain_name = "${var.domain_name}"
  validation_method = "DNS"
  tags = "${merge("${var.tags}", map("Name", "${var.project_tag}-${var.environment_tag}-${var.domain_tag}", "Environment", "${var.environment_tag}", "Project", "${var.project_tag}"))}"
}

resource "aws_route53_record" "cert-validation-record" {
  name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.hosted_zone_id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
