variable "aws_region" {
  description = "The name of the AWS region"
}

variable "account_id" {
  description = "The account ID"
}

variable "terraform_role_name" {
  description = "The name of the role to assume"
}

variable "external_access_role_name" {
  description = "The name of the role given to external users"
}
