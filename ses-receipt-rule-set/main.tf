resource "aws_ses_receipt_rule_set" "rule-set" {
  rule_set_name = "${var.rule_set_name}"
}

resource "aws_ses_active_receipt_rule_set" "rule-set" {
  rule_set_name = "${var.rule_set_name}"
}
