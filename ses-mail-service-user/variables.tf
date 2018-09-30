variable "account_id" {
  description = "The account ID of the SES domain to send from"
}

variable "email_domain" {
  description = "The domain to send emails from"
}

variable "user_name" {
  description = "The name of the service user to create (automatically prefixed by 'ses.emailer-')"
}