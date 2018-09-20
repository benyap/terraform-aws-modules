variable "account_id" {
  description = "The account ID"
}

variable "aws_region" {
  description = "The AWS region resources will reside in by default"
}

variable "role_name" {
  description = "The name of the role to assume to create the SES domain identity"
}

variable "email_domain" {
  description = "The domain of the email this lambda will forward from"
}

variable "rule_name" {
  description = "A unique name for the resources created by this rule"
}

variable "lambda_from_email" {
  description = "Forwarded emails will come from this verified address "
}

variable "lambda_subject_prefix" {
  description = "Forwarded emails subject will contain this prefix "
}

variable "lambda_forward_mapping" {
  description = "JSON string of object where the key is the lowercase email address from which to forward and the value is an array of email addresses to which to send the message."
}

variable "rule_set_name" {
  description = "The name of the rule set to add SES forwarding rules to"
}

variable "rule_set_recipients" {
  description = "The list of recipients for the rule set"
  type = "list"
}

variable "after" {
  description = "The name of the rule to position this rule after"
  default     = ""
}
