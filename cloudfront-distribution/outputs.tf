output "cdn_domain_name" {
  value = "${var.logging_enabled ?
    element(aws_cloudfront_distribution.domain-cdn-with-logging.*.domain_name, 0) :
    element(aws_cloudfront_distribution.domain-cdn.*.domain_name, 0)
  }"
}

output "hosted_zone_id" {
  value = "${var.logging_enabled ?
    element(aws_cloudfront_distribution.domain-cdn-with-logging.*.hosted_zone_id, 0) :
    element(aws_cloudfront_distribution.domain-cdn.*.hosted_zone_id, 0)
  }"
}
