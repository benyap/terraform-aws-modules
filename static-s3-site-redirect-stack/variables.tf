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

variable "redirect_target" {
  description = "The target URL to redirect to"
}

variable "secret" {
  description = "Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket"
}
