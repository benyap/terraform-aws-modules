# External Access

This module sets up the external trust relationships for this account.
This allows users to assume a role within this account from an external account.
Note that the role by default will have no policies attached to it.

To use this module in your configuration, use this repository as a source:

```hcl
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//external-access"

  aws_region                = "${var.aws_region}"
  account_id                = "${var.account_id}"
  terraform_role_name       = "${var.terraform_role_name}"
  external_access_role_name = "${var.external_access_role_name}"

  allowed_arns = [
    "arn:aws:iam::${var.account_id}:root",
    ...
  ]
}
```

## Required variables

- `aws_region`: The region the AWS resources will be created in.

- `account_id`: The account ID fo the root AWS account.

- `terraform_role_name`: The name of the role that Terraform will use.

- `external_access_role_name`: The name of the role given to the external users.

- `allowed_arns`: A list of ARNs of IAM users that are allowed to assume the external access role.
This list should include the root account `arn:aws:iam::${var.account_id}:root`.


## Outputs

- `role_arn`

- `role_name`

- `role_unique_id`

- `role_description`

- `role_create_date`


## Pre-requisites

To apply this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:GetRole",
        "iam:AttachRolePolicy",
        "iam:ListAttachedRolePolicies"
      ],
      "Resource": [
        "arn:aws:iam::${account_id}:role/${external_access_role_name}"
      ]
    }
  ]
}
```

To destroy this configuration, you require the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:ListAttachedRolePolicies",
        "iam:ListInstanceProfilesForRole",
        "iam:DetachRolePolicy",
        "iam:DeleteRole"
      ],
      "Resource": [
        "arn:aws:iam::${account_id}:role/${external_access_role_name}"
      ]
    }
  ]
}
```
