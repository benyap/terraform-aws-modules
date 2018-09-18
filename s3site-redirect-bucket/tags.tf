variable "tags" {
  type        = "map"
  description = "Optional tags"
  default     = {}
}

variable "project_tag" {
  description = "The value for the tag 'Project'"
}

variable "environment_tag" {
  description = "The value for tag 'Environment'"
}

variable "domain_tag" {
  description = "The value for the tag 'Domain'"
}

output "name_tag" {
  description = "The value of the 'Name' tag"
  value = "${var.project_tag}-${var.environment_tag}-${var.domain_tag}"
}
