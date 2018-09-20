#######################
# Setup
#######################

# Create AWS provider in us-east-1
provider "aws" {
  region  = "us-east-1"
  version = "~>1.36"

  # Assume the terraform role to give access to AWS resources.
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.role_name}"
  }
}


########################
# Configuration
########################

resource "aws_ses_receipt_rule_set" "rule-set" {
  rule_set_name = "${var.rule_set_name}"
}

resource "aws_ses_active_receipt_rule_set" "rule-set" {
  rule_set_name = "${var.rule_set_name}"
}
