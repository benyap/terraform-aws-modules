#######################
# Configuration
#######################

# Create policy which allows public access to bucket contents in the `public` directory
data "aws_iam_policy_document" "s3-resource-bucket-policy" {
  statement {
    sid     = "PublicReadAccess"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/public/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

# Create the S3 bucket
resource "aws_s3_bucket" "s3-resource-bucket" {
  bucket    = "${var.bucket_name}"
  policy    = "${data.aws_iam_policy_document.s3-resource-bucket-policy.json}"
  region    = "${var.aws_region}"

  tags = "${merge("${var.tags}",
    map(
      "Name", "${var.project_tag}-${var.environment_tag}-${var.type_tag}",
      "Environment", "${var.environment_tag}",
      "Project", "${var.project_tag}"
    )
  )}"
}

# Create IAM user with access to bucket
resource "aws_iam_user" "user" {
  name = "s3resource.accessor-${var.environment_tag}"
  path = "/serviceuser/"
}

# Create policy for IAM user
resource "aws_iam_user_policy" "user-policy" {
  name = "s3resource.accessor.policy-${var.environment_tag}"
  user = "${aws_iam_user.user.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": ["${var.bucket_name}"]
    }
  ]
}
EOF
}
