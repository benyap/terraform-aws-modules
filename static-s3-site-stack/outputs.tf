output "bucket_id" {
  description = "The name of the bucket"
  value       = module.site-bucket.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.site-bucket.bucket_arn
}

output "bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region"
  value       = module.site-bucket.bucket_hosted_zone_id
}

output "website_endpoint" {
  description = "The S3 static site endpoint URL"
  value       = module.site-bucket.website_endpoint
}

output "certificate_arn" {
  description = "The ARN of the certificate assigned to the Cloudfront distribution"
  value       = module.site-cert.certificate_arn
}

output "cdn_domain_name" {
  description = "The domain name of the Cloudfront distribution"
  value       = module.site-cdn.cdn_domain_name
}
