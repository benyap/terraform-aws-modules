output "cdn_domain_name" {
  value = "${var.logging_enabled ?
    element(concat(aws_cloudfront_distribution.external-domain-cdn-with-logging.*.domain_name, list("")), 0) :
    element(concat(aws_cloudfront_distribution.external-domain-cdn.*.domain_name, list("")), 0)
  }"
}

output "hosted_zone_id" {
  value = "${var.logging_enabled ?
    element(concat(aws_cloudfront_distribution.external-domain-cdn-with-logging.*.hosted_zone_id, list("")), 0) :
    element(concat(aws_cloudfront_distribution.external-domain-cdn.*.hosted_zone_id, list("")), 0)
  }"
}
