output "bucket_id" {
  description = "The name of the bucket"
  value = "${aws_s3_bucket.s3-resource-bucket.id}"
}
output "bucket_arn" {
  description = "The ARN of the bucket"
  value = "${aws_s3_bucket.s3-resource-bucket.arn}"
}
