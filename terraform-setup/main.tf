#######################
# Setup
#######################

# Create the default AWS provider
provider "aws" {
  region  = "${var.aws_region}"
  version = "~>1.35"
}

provider "template" {
  version = "~>1.0"
}


#############
#  MODULES  #
#############

# Create role for Terraform user
data "aws_iam_policy_document" "terraform-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "terraform-role" {
  name = "${var.terraform_role_name}"
  description = "This role gives Terraform users permissions to manage infrastructure"
  assume_role_policy = "${data.aws_iam_policy_document.terraform-role-policy.json}"
}


# Create S3 bucket for backend
resource "aws_s3_bucket" "backend-bucket" {
  bucket = "${var.backend_bucket_name}"
  region = "${var.aws_region}"
  acl    = "private"
}


# Create policy for Terraform users to access S3 bucket
data "aws_iam_policy_document" "terraform-state-policy-document" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:ListAllMyBuckets",
      "s3:HeadBucket"
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "s3:ListBucket",
      "s3:ListObjects",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.backend-bucket.arn}",
      "${aws_s3_bucket.backend-bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "terraform-state-policy" {
  name        = "TerraformStateBucketAccess"
  path        = "/terraform/"
  description = "This policy allows access to the S3 bucket storing Terraform state."
  policy      = "${data.aws_iam_policy_document.terraform-state-policy-document.json}"
}


# Attach backend access policy to Terraform role
resource "aws_iam_role_policy_attachment" "attachment" {
    role       = "${aws_iam_role.terraform-role.name}"
    policy_arn = "${aws_iam_policy.terraform-state-policy.arn}"
}


# Create policy for Terraform users to switch to role
data "aws_iam_policy_document" "terraform-switch-role-policy-document" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.account_id}:role/${var.terraform_role_name}"]
  }
}

resource "aws_iam_policy" "terraform-switch-role-policy" {
  name        = "TerraformSwitchRole"
  path        = "/terraform/"
  description = "This policy allows users to switch to the Terraform role."
  policy      = "${data.aws_iam_policy_document.terraform-switch-role-policy-document.json}"
}


# Create group for Terrafrom users
resource "aws_iam_group" "terraform-group" {
  name = "${var.terraform_group_name}"
  path = "/terraform/"
}


# Attach policies to group
resource "aws_iam_group_policy_attachment" "terraform-group-attach-state-policy" {
  group      = "${aws_iam_group.terraform-group.name}"
  policy_arn = "${aws_iam_policy.terraform-state-policy.arn}"
}

resource "aws_iam_group_policy_attachment" "terraform-group-attach-role-policy" {
  group      = "${aws_iam_group.terraform-group.name}"
  policy_arn = "${aws_iam_policy.terraform-switch-role-policy.arn}"
}
