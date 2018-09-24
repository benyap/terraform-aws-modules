########################
# Configuration
########################

locals {
  bucket_name = "${var.email_domain}-emails"
}


########################
# Create S3 bucket
########################

# Create policy which allows SES to put objects in bucket
data "aws_iam_policy_document" "bucket-policy-document" {
  statement {
    sid     = "AllowSESPuts"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"
      values = ["${var.account_id}"]
    }
  }
}

# Create bucket to store emails
resource "aws_s3_bucket" "email-bucket" {
  bucket = "${local.bucket_name}"
  policy = "${data.aws_iam_policy_document.bucket-policy-document.json}"

  lifecycle_rule {
    id      = "email-rule"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class = "ONEZONE_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

  tags {
    Project     = "${var.project_tag}"
    Environment = "${var.environment_tag}"
    Name        = "${var.project_tag}-${var.environment_tag}-${var.type_tag}"
  }
}

