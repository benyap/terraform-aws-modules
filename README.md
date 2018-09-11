# terraform-aws-modules
A collection of modules for configuring AWS resources through Terraform. For convenience.

## Installation

You will need Terraform installed on your computer. Go to [terraform.io](https://www.terraform.io/) to download. Make sure the command `terraform` is available from the command line.

## How to run these configurations

Each of these configurations contain a `README.md` file in its root, where it will detail what the configuration does, and what pre-requisites are required.

If it is your first time running a configuration, you will need to do the following:

1. Set up the AWS credentials with the details of the IAM user Terraform will be using in the AWS credentials file at `~/.aws/credentials` like so: 

```
[PROFILE_NAME]
aws_access_key_id=********************
aws_secret_access_key=****************************************
```

2. Switch to the profile by exporting the name of the profile to the variable AWS_PROFILE:

```bash
export AWS_PROFILE=PROFILE_NAME
```

3. Run `terraform init` in the root of the configuration to initialise Terraform and download plugins.

Once you have completed all pre-requisites for a configuration, you can apply the configuration to your AWS infrastructure.

1. Run the command `terraform plan` to see how Terraform will change your infrastructure.

2. Run the command `terraform apply` to actually apply the configuration to your infrastructure.

3. If you ever need to destroy infrastructure created by Terraform, run `terraform destroy`.

For more information on how to use Terraform, go to the [documentation](https://www.terraform.io/intro/getting-started/install.html).
