########################
# Configuration
########################

data "aws_s3_bucket" "email-bucket" {
  bucket = "${var.bucket_name}"
}

resource "aws_ses_receipt_rule" "bounce-email" {
  name          = "${var.email_domain}-${var.rule_name}-bounce_rule"
  rule_set_name = var.rule_set_name
  enabled       = true
  scan_enabled  = true
  recipients    = var.bounce_recipients
  after         = var.after

  s3_action {
    bucket_name       = var.bucket_name
    object_key_prefix = var.email_object_prefix
    position          = 1
  }

  bounce_action {
    message         = var.bounce_message
    sender          = var.bounce_sender
    smtp_reply_code = "550"
    status_code     = "5.1.1"
    position        = 2
  }
}
