variable "aws_region" {
  description = "The name of the AWS region"
}

variable "account_id" {
  description = "The account ID"
}

variable "backend_bucket_name" {
  description = "The name of the bucket to store the state in"
}

variable "terraform_role_name" {
  description = "The name of the role for Terraform users"
  default     = "terraform.role"
}

variable "terraform_group_name" {
  description = "The name of the group for Terraform users"
  default     = "terraform-users"
}
