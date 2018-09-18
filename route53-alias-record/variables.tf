variable "record_zone_id" {
  description = "The ID of the hosted zone in which the domain record is in"
}

variable "domain_name" {
  description = "The name of the domain for this record"
}

variable "cdn_zone_id" {
  description = "The ID of the hosted zone where the CloudFront distribution is in"
}

variable "cdn_domain_name" {
	description = "The domain for the CloudFront distribution this record should point to"
}
