# SES mail bouncer

_Terraform version: `v0.12.x`_

This module configures SES to bounce emails on a custom domain, storing them in an **existing** S3 bucket.

You can use the [`ses-mail-bucket`](https://github.com/bwyap/terraform-aws-modules/tree/master/ses-mail-bucket) module to create an S3 bucket that is pre-configured for use by this module.

**Note that this module requires a provider in the region `us-east-1`.**

To use this module in your configuration, use this repository as a source:

```hcl
# Example usage
module "MODULE_NAME" {
  source = "git@github.com:bwyap/terraform-aws-modules.git//ses-mail-bouncer"

  providers = {
    aws = "aws.us-east-1-provider"
  }

  email_domain  = var.domain_name
  bucket_name   = var.bucket_name
  rule_name     = "bounce_noreply"

  email_object_prefix     = "bounced/"

  rule_set_name       = var.rule_set_name
  bounce_recipients   = ["noreply@${var.domain_name}"]
  bounce_message      = "You cannot reply to this mailbox."
  bounce_sender       = "noreply@${var.domain_name}"
}
```

## Required variables

- `email_domain`: The domain of the email to bounce on.

- `bucket_name`: The name of the bucket that bounced emails will be placed in.

- `rule_name`: A unique name for the resources created by this rule.

- `rule_set_name`: The name of the rule set to create and add SES forwarding rules to.

- `bounce_recipients`: The list of recipients to bounce for the rule set.

- `bounce_sender`: The email to send the bounce message from.

## Optional variables

- `email_object_prefix`: (OPTIONAL) The prefix to add to the object name in S3 (default is "bounced/").

- `bounce_message`: (OPTIONAL) The message to send to the sender when the message is bounced (default is "Unable to deliver this message.").

- `after`: (OPTIONAL) The name of the rule to position this rule after (default is "").

## Outputs

- `bouncer_rule_name`: The name of the bouncer rule that was created.

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
