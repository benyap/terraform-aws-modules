#######################
# Configuration
#######################

# User for deploying to qat
resource "aws_iam_user" "deployment-user" {
  name = "s3site.deployer.${var.user_name}"
  path = "/serviceuser/"
  force_destroy = true
}

# Give user required access to specified site bucket
resource "aws_iam_user_policy" "deployment-user-policy" {
  name = "AllowAccessS3SiteServiceUser-${var.user_name}"
  user = "${aws_iam_user.deployment-user.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.bucket_name}*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "s3:CreateBucket",
        "s3:DeleteBucket",
        "s3:DeleteBucketPolicy",
        "s3:DeleteBucketWebsite"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
