variable "role_name" {
  description = "The name of the role"
}

variable "role_description" {
  description = "The description of the role"
}

variable "allowed_arns" {
  description = "The external ARNs that are allowed to access this role"
  type = "list"
}
