output "bouncer_rule_name" {
  value = "${aws_ses_receipt_rule.bounce-email.name}"
}
