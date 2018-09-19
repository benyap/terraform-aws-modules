output "cdn_domain_name" {
  value = "${var.logging_enabled ? aws_cloudfront_distribution.domain-cdn-with-logging.0.domain_name : aws_cloudfront_distribution.domain-cdn.0.domain_name}"
}

output "hosted_zone_id" {
  value = "${var.logging_enabled ? aws_cloudfront_distribution.domain-cdn-with-logging.0.hosted_zone_id : aws_cloudfront_distribution.domain-cdn.0.hosted_zone_id}"
}
