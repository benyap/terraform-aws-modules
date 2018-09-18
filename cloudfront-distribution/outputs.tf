output "cdn_domain_name" {
	value = "${aws_cloudfront_distribution.domain-cdn.domain_name}"
}

output "hosted_zone_id" {
	value = "${aws_cloudfront_distribution.domain-cdn.hosted_zone_id}"
}
