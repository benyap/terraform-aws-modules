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

output "name_tag" {
  description = "The value of the 'Name' tag"
  value = "${var.project_tag}-${var.environment_tag}-s3_bucket"
}
