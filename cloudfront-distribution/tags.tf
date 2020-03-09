variable "tags" {
  type        = map(string)
  description = "Optional tags"
  default     = {}
}

variable "project_tag" {
  description = "The value for the tag 'Project'"
}

variable "environment_tag" {
  description = "The value for tag 'Environment'"
}

variable "type_tag" {
  description = "The value for the tag 'Type'"
}

output "name_tag" {
  description = "The value of the 'Name' tag"
  value       = "${var.project_tag}-${var.environment_tag}-${var.type_tag}"
}
