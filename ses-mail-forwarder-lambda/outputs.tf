output "forwarder_rule_name" {
  value = "${aws_ses_receipt_rule.store-and-forward-email.name}"
}
