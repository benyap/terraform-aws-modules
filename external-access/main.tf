#######################
# Configuration
#######################

# Create a role with the specified name and allow specified ARNs to access this role
resource "aws_iam_role" "external-role" {
  name            = "${var.external_access_role_name}"
  description     = "${var.external_access_role_description}"

  assume_role_policy = "${data.aws_iam_policy_document.external-role-policy.json}"
}

data "aws_iam_policy_document" "external-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = "${var.allowed_arns}"
    }
  }
}
