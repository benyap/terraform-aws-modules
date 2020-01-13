########################
# Configuration
########################

# Create the SES domain
resource "aws_ses_domain_identity" "ses-domain-identity" {
  domain = var.email_domain
}

# Create verification record
resource "aws_route53_record" "ses-domain-identity-verification-record" {
  zone_id = var.hosted_zone_id
  name    = "_amazonses.${var.email_domain}"
  type    = "TXT"
  ttl     = "600"
  records = ["${aws_ses_domain_identity.ses-domain-identity.verification_token}"]
}

# Verify using Route53
resource "aws_ses_domain_identity_verification" "domain_verification" {
  domain     = aws_ses_domain_identity.ses-domain-identity.id
  depends_on = ["aws_route53_record.ses-domain-identity-verification-record"]
}

# Set up DKIM and Route53 records
resource "aws_ses_domain_dkim" "ses-domain-dkim" {
  domain = aws_ses_domain_identity.ses-domain-identity.domain
}

resource "aws_route53_record" "domain-amazonses-verification-record" {
  count   = 3
  zone_id = var.hosted_zone_id
  name    = "${element(aws_ses_domain_dkim.ses-domain-dkim.dkim_tokens, count.index)}._domainkey.${var.email_domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.ses-domain-dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

# Set up MX inbound Route53 record
resource "aws_route53_record" "ses-domain-mx-inbound-record" {
  zone_id = var.hosted_zone_id
  name    = var.email_domain
  type    = "MX"
  ttl     = "1800"
  records = ["10 inbound-smtp.us-east-1.amazonaws.com"]
}
