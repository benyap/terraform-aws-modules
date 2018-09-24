variable "bucket_name" {
  description = "The name of the bucket that bounced emails will be placed in"
}

variable "rule_name" {
  description = "A unique name for the resources created by this rule"
}

variable "email_object_prefix" {
  description = "The prefix to add to the object name in S3"
  default      = "bounced/"
}

variable "rule_set_name" {
  description = "The name of the rule set to add SES forwarding rules to"
}

variable "bounce_recipients" {
  description = "The list of recipients to bounce for the rule set"
  type = "list"
}

variable "bounce_message" {
  description = "The message to send to the sender when the message is bounced"
  default = "Unable to deliver this message."
}

variable "bounce_sender" {
  description = "The email to send the bounce message from"
}

variable "after" {
  description = "The name of the rule to position this rule after"
  default     = ""
}
