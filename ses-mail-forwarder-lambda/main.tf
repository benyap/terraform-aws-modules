########################
# Create forwarding lambda
########################

# Lambda role for forwarding emails
resource "aws_iam_role" "fwd-lambda-role" {
  name               = "${var.email_domain}-${var.rule_name}-fwd_lambda_role"
  description        = "Lambda execution role for forwarding emails from @${var.email_domain} for SES rule ${var.rule_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Create policy which allows SES to put objects in bucket
data "aws_iam_policy_document" "fwd-lambda-policy-document" {
  statement {
    sid    = "AllowLambdaLogPuts"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid       = "AllowLambdaSendEmails"
    effect    = "Allow"
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowLambdaGetPutS3Objects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
}

resource "aws_iam_policy" "fwd-lambda-policy" {
  name        = "${var.email_domain}-${var.rule_name}-fwd_lambda_policy"
  description = "Lambda policy for forwarding emails from @${var.email_domain} for SES rule ${var.rule_name}"
  policy      = data.aws_iam_policy_document.fwd-lambda-policy-document.json
}

resource "aws_iam_role_policy_attachment" "fwd-lambda-role-policy" {
  role       = aws_iam_role.fwd-lambda-role.name
  policy_arn = aws_iam_policy.fwd-lambda-policy.arn
}

# Zip up lambda script
data "archive_file" "lambda-source" {
  type        = "zip"
  source_file = "${path.module}/lambda.js"
  output_path = "${path.module}/lambda.js.zip"
}

# Create Lambda function
resource "aws_lambda_function" "fwd-lambda" {
  filename         = "${path.module}/lambda.js.zip"
  function_name    = "${replace(var.email_domain, ".", "_")}-${var.rule_name}-forwarder"
  description      = "Forwards emails to ${var.bucket_name} for the SES rule ${var.rule_name}"
  role             = aws_iam_role.fwd-lambda-role.arn
  handler          = "lambda.handler"
  source_code_hash = data.archive_file.lambda-source.output_base64sha256
  runtime          = "nodejs12.x"

  environment {
    variables = {
      fromEmail      = var.lambda_from_email
      subjectPrefix  = var.lambda_subject_prefix
      emailBucket    = var.bucket_name
      emailKeyPrefix = var.email_object_prefix
      forwardMapping = var.lambda_forward_mapping
    }
  }

  tags = merge(var.tags,
    map(
      "Name", "${var.project_tag}-${var.environment_tag}-${var.type_tag}",
      "Environment", var.environment_tag,
      "Project", var.project_tag
    )
  )
}

# Allow Lambda to execute SES functions
resource "aws_lambda_permission" "allow-ses" {
  statement_id  = "AllowExecutionFromSES"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fwd-lambda.function_name
  principal     = "ses.amazonaws.com"
}

########################
# Create rule set
########################

resource "aws_ses_receipt_rule" "store-and-forward-email" {
  name          = "${var.email_domain}-${var.rule_name}-fwd_receipt_rule"
  rule_set_name = var.rule_set_name
  enabled       = true
  scan_enabled  = true
  recipients    = var.rule_set_recipients
  after         = var.after

  s3_action {
    bucket_name       = var.bucket_name
    object_key_prefix = var.email_object_prefix
    position          = 1
  }

  lambda_action {
    function_arn    = aws_lambda_function.fwd-lambda.arn
    invocation_type = "Event"
    position        = 2
  }
}
