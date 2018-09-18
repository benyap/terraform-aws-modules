output "record_name" {
  value = "${aws_route53_record.route53-alias.name}"
}

output "fqdn" {
  value = "${aws_route53_record.route53-alias.fqdn}"
}
