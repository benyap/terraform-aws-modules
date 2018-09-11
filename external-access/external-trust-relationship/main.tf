# Create a role with the specified name and allow specified ARNs to access this role
resource "aws_iam_role" "role" {
  name = "${var.role_name}"
  description = "${var.role_description}"
  assume_role_policy = "${data.aws_iam_policy_document.role-policy.json}"
}

data "aws_iam_policy_document" "role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = "${var.allowed_arns}"
    }
  }
}
