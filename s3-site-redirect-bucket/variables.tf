variable "aws_region" {
  description = "The AWS region the website bucket will reside in"
}

variable "bucket_name" {
  description = "The name of the bucket that holds the website assets"
}

variable "duplicate_content_penalty_secret" {
  description = "Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket"
}

variable "redirect_target" {
  description = "The target URL to redirect to"
}

variable "redirect_protocol" {
  description = "The protocol to use for the redirect URL (default to HTTPS)"
  default     = "https"
}
