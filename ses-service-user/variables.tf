variable "account_id" {
  description = "The account ID"
}

variable "ses_region" {
  description = "The region SES is configured in"
}

variable "domain_identity" {
  description = "The name of the domain through which emails are to be sent"
}

variable "user_name" {
  description = "The name of the service user to create (automatically prefixed by 'ses.emailer-')"
}
