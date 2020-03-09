#######################
# Configuration
#######################

# User for accessing SES services
resource "aws_iam_user" "user" {
  name          = "ses.emailer-${var.user_name}"
  path          = "/serviceuser/"
  force_destroy = true
}

# Give user required access to SES
resource "aws_iam_user_policy" "user-policy" {
  name = "ses.emailer-policy-${var.user_name}"
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ses:SendRawEmail",
      "Effect": "Allow",
      "Resource": "arn:aws:ses:${var.ses_region}:${var.account_id}:identity/${var.domain_identity}"
    }
  ]
}
EOF
}
