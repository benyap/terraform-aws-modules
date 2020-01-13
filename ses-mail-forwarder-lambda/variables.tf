variable "bucket_name" {
  description = "The name of the S3 bucekt to store emails in"
}

variable "email_domain" {
  description = "The domain of the email this lambda will forward from"
}

variable "email_object_prefix" {
  description = "The prefix to add to the object name in S3"
  default     = "forwarded/"
}

variable "rule_name" {
  description = "A unique name for the resources created by this rule"
}

variable "lambda_from_email" {
  description = "Forwarded emails will come from this verified address"
}

variable "lambda_subject_prefix" {
  description = "Forwarded emails subject will contain this prefix"
  default     = ""
}

variable "lambda_forward_mapping" {
  description = "JSON string of object where the key is the lowercase email address from which to forward and the value is an array of email addresses to which to send the message"
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
