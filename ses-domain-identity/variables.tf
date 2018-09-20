variable "account_id" {
  description = "The account ID"
}

variable "role_name" {
  description = "The name of the role to assume to create the SES domain identity"
}

variable "email_domain" {
  description = "The custom email domain to use for SES"
}

variable "hosted_zone_id" {
  description	= "The id of the hosted zone the domain was registered in"
}
