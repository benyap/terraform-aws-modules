########################
# Configuration
########################

resource "aws_ses_receipt_rule" "bounce-email" {
  name          = "${var.email_domain}-${var.rule_name}-bounce_rule"
  rule_set_name = var.rule_set_name
  enabled       = true
  scan_enabled  = true
  recipients    = var.bounce_recipients
  after         = var.after

  bounce_action {
    message         = var.bounce_message
    sender          = var.bounce_sender
    smtp_reply_code = "550"
    status_code     = "5.1.1"
    position        = 1
  }

  stop_action {
    scope    = "RuleSet"
    position = 2
  }
}
