variable "aws_region" {
  description = "The name of the AWS region"
}

variable "account_id" {
  description = "The account ID"
}

variable "terraform_role_name" {
  description = "The name of the role to assume"
  default     = "terraform.admin"
}

variable "external_access_role_name" {
  description = "The name of the role given to external users"
  default     = "external.role"
}

variable "external_access_role_description" {
  description = "The description for the external role"
  default     = "External user role."
}

variable "allowed_arns" {
  description = "A list of ARNs that are allowed to assume the external access role"
  default     = []
}
