#######################
# Configuration
#######################

# User for sending emails through SES
resource "aws_iam_user" "ses-user" {
  name = "ses.emailer-${var.user_name}"
  path = "/serviceuser/"
  force_destroy = true
}

# Give user required access to SES
resource "aws_iam_user_policy" "ses-user-policy" {
  name = "AllowAccessSESServiceUser-${var.user_name}"
  user = "${aws_iam_user.ses-user.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ses:SendRawEmail",
      "Effect": "Allow",
      "Resource": "arn:aws:ses:us-east-1:${var.account_id}:identity/${var.email_domain}"
    }
  ]
}
EOF
}
