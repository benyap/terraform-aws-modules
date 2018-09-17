#######################
# Configuration
#######################

# Create policy which allows public access to bucket contents
data "aws_iam_policy_document" "s3site-bucket-policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:UserAgent"
      values = ["${var.duplicate_content_penalty_secret}"]
    }
  }
}

# Create the S3 bucket for static website hosting
resource "aws_s3_bucket" "s3site-bucket" {
  bucket    = "${var.bucket_name}"
  policy    = "${data.aws_iam_policy_document.s3site-bucket-policy.json}"
  region    = "${var.aws_region}"

  website {
    index_document  = "${var.index_document}"
    error_document  = "${var.error_document}"
    routing_rules   = "${var.routing_rules}"
  }
}
