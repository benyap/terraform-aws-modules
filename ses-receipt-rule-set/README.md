# SES receipt rule set

_Terraform version: `v0.13.x`_

This module creates and activates an SES receipt rule set.

**Note that this module requires a provider in the region `us-east-1`.**

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-receipt-rule-set"

  providers = {
    aws = "aws.us-east-1-provider"
  }

  rule_set_name = var.rule_set_name
}
```

## Required variables

- `rule_set_name`: The name of the receipt rule set to create and activate.

## Outputs

- `rule_set_name`: The name of the receipt rule set.

## Pre-requisites

To apply or destroy this configuration, you require the following permissions on the IAM user used to run this configuration:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ses:*"],
      "Resource": ["*"]
    }
  ]
}
```
