variable "bucket_name" {
  description = "The name of the S3 bucekt to store emails in"
}

variable "email_domain" {
  description = "The domain of the email this lambda will forward from"
}

variable "rule_name" {
  description = "A unique name for the resources created by this module"
}

variable "email_object_prefix" {
  description = "The prefix to add to the object name in S3"
}

variable "lambda_from_email" {
  description = "Forwarded emails will come from this verified address"
}

variable "lambda_default_recipient" {
  description = "If this is provided, unmapped emails will be sent to this address"
}

variable "lambda_prefix_mapping" {
  description = "JSON string of mapping of intended recipient address to email subject prefix"
}

variable "lambda_forward_mapping" {
  description = "JSON string of mapping of intended recipient address to forward destination address"
}

variable "rule_set_name" {
  description = "The name of the rule set to create and add SES forwarding rules to"
}

variable "rule_set_recipients" {
  description = "The list of accepted recipients for the rule set"
  type        = list(string)
}

variable "after" {
  description = "The name of the rule to position this rule after"
  default     = ""
}
