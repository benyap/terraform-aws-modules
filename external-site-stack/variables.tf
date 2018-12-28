variable "aws_region" {
  description = "The name of the AWS region"
}

variable "account_id" {
  description = "The account ID"
}

variable "terraform_role_name" {
  description = "The name of the role for Terraform to use"
}

variable "domain_name" {
  description = "The name of the domain to create"
}

variable "external_site_origin" {
  description = "The origin URL of the external site to point to"
}

variable "domain_env_prefix" {
  description = "The domain prefix to the root domain"
  default     = ""
}

variable "environment_tag" {
  description = "The value for tag 'Environment'"
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone in which the domain record is in"
}

variable "index_document" {
  description = "The name of the index file for the website"
  default     = ""
}

variable "error_document" {
  description = "The name of the error file for the website"
  default     = ""
}

variable "forwarded_headers" {
  description = "Headers for Cloudfront to forward from the host request"
  default = []
}

variable "custom_headers" {
  description = "Custom headers for Cloudfront add to requests"
  default = []
}
