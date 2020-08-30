variable "email_domain" {
  description = "The domain of the email to bounce on"
}

variable "rule_name" {
  description = "A unique name for the resources created by this rule"
}

variable "rule_set_name" {
  description = "The name of the rule set to add SES forwarding rules to"
}

variable "bounce_recipients" {
  description = "The list of recipients to bounce for the rule set"
  type        = list(string)
}

variable "bounce_message" {
  description = "The message to send to the sender when the message is bounced"
  default     = "Unable to deliver this message."
}

variable "bounce_sender" {
  description = "The email to send the bounce message from"
}

variable "after" {
  description = "The name of the rule to position this rule after"
  default     = ""
}
