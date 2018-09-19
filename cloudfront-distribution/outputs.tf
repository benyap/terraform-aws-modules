output "cdn_domain_name" {
	value = "${aws_cloudfront_distribution.domain-cdn.0.domain_name}"
}

output "hosted_zone_id" {
	value = "${aws_cloudfront_distribution.domain-cdn.0.hosted_zone_id}"
}
