output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.s3-site-bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.s3-site-bucket.arn
}

output "bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region"
  value       = aws_s3_bucket.s3-site-bucket.arn
}

output "website_endpoint" {
  description = "The website endpoint"
  value       = aws_s3_bucket.s3-site-bucket.website_endpoint
}
