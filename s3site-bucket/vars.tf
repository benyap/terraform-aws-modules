variable "region" {
  description = "The region the website bucket will reside in"
}

variable "bucket_name" {
  description = "The name of the bucket that holds the website assets"
}

variable "duplicate_content_penalty_secret" {
  description = "Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket"
}

variable "index_document" {
  description = "The name of the index file for the website"
}

variable "error_document" {
  description = "The name of the error file for the website"
}

variable "routing_rules" {
  description = "Routing rules for the S3 website"
  default = "[]"
}
