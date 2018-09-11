# External Access

This module sets up the external trust relationships for this account.
This allows users to assume a role within this account from an external account.
Note that the role by default will have no policies attached to it.
You can customise this by adding policy attachments in `main.tf`.


## Variables required in `terraform.tfvars`

- `aws_region`: The region the AWS resources will be created in

- `account_id`: The account ID fo the root AWS account

- `terraform_role_name`: The name of the role that Terraform will use

- `external_access_role_name`: The name of the role given to the external users


## Variables required in `main.tf`

- `allowed_arns`: the list of ARNs of IAM users that will be given access to this account.
This list should include the root account `arn:aws:iam::${var.account_id}:root`.
Find this variable in the `external-trust-relationship` module.


## Pre-requisites

1. Run the `terraform-setup` configuration to create the appropriate roles and permissions. Assign administrator permissions to the `terraform.admin` role.

2. Set up an IAM user account add it to the group `terraform-users`. This will allow Terraform to assume the `terraform.admin` role to provision the necessary resources. Add the user's credentials to ~/.aws/credentials like so:

```
[PROFILE_NAME]
aws_access_key_id=********************
aws_secret_access_key=****************************************
```

3. Set the `AWS_PROFILE` variable to use the profile from step 2.

```
export AWS_PROFILE=PROFILE_NAME
```

4. You are now ready to run this Terraform configuration.
