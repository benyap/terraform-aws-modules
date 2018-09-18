#######################
# Configuration
#######################

# Create policy which allows public access to bucket contents
data "aws_iam_policy_document" "s3site-bucket-policy" {
  statement {
    sid     = "AllowPublicRead"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

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
  acl       = "public-read"

  tags = "${merge("${var.tags}", map("Name", "${var.project_tag}-${var.environment_tag}-${var.domain_tag}", "Environment", "${var.environment_tag}", "Project", "${var.project_tag}"))}"

  website {
    redirect_all_requests_to = "${var.redirect_protocol}://${var.redirect_target}"
  }
}