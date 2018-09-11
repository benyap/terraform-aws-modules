#######################
# Setup
#######################

# Configure the backend to use a remote state
terraform {
  backend "s3" {
    bucket  = "<BUCKET_NAME>"
    key     = "<STATE_FILE_NAME>"
    region  = "<REGION>"
    encrypt = true
  }
}

# Create the default AWS provider
provider "aws" {
  region  = "${var.aws_region}"
  # You may want to update this.
  version = "~>1.35"

  # Assume the terraform role to give access to AWS resources.
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.terraform_role_name}"
  }
}

provider "template" {
  version = "~>1.0"
}


#######################
# Configuration
#######################

# Create a trust relationship between external users and a role in this account
module "external-trust-relationship" {
  source = "./external-trust-relationship"

  role_name         = "${var.external_access_role_name}"
  role_description  = "External user role."

  allowed_arns = [
    "arn:aws:iam::${var.account_id}:root",
    "<IAM_USER_ARN>"
  ]
}

## EXAMPLE

# # Attach administrator policy to role
# resource "aws_iam_role_policy_attachment" "attachment" {
#     role       = "${module.external-trust-relationship.name}"
#     policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }
