variable "origin_id" {
  description = "The name for the origin"
}

variable "website_endpoint" {
  description = "The endpoint URL for the distribution"
}

variable "forward_query_string" {
  description = "Forward the query string to the origin (default is false)"
  default = false
}

variable "certificate_arn" {
  description = "The id of an SSL certificate for this domain from AWS Certificate Manager"
}

variable "domain_aliases" {
  description = "Alternate domain names (CNAME) for this distribution"
  default     = []
}

variable "index_document" {
  description = "The index document file name for the site"
  default     = ""
}

variable "error_document" {
  description = "The error document file name for the site"
  default     = ""
}

variable "logging_enabled" {
  description = "Set this to true to enable logging to an S3 bucket (default is false)"
  default     = false
}

variable "logging_bucket" {
  description = "The name of the S3 bucket to record logs in"
  default     = ""
}

variable "logging_prefix" {
  description = "The prefix to attach to logs in the logging bucket"
  default     = ""
}

variable "allowed_methods" {
  description = "The allowed methods for this distribution"
  default     = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
}
