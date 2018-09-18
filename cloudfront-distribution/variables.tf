variable "bucket_id" {
  description = "The name of the S3 bucket the website is hosted on"
}

variable "website_endpoint" {
  description = "The endpoint URL for the S3 site"
}

variable "duplicate_content_penalty_secret" {
  description = "Value that will be used in a custom header for a CloudFront distribution to gain access to the origin S3 bucket"
}

variable "forward_query_string" {
  description = "Forward the query string to the origin (default is false)"
  default = false
}

variable "certificate_arn" {
  description = "The id of an SSL certificate for this domain from AWS Certificate Manager"
}

variable "index_document" {
  description = "The index document file name for the site"
}

variable "error_document" {
  description = "The error document file name for the site"
}

variable "domain_alias" {
  description = "Alternate domain name (CNAME) for this distribution"
}
