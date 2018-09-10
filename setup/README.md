# Set up

// TODO: description

## How to use this module

1. Create an IAM user on the AWS console and allow programmatic access.
Save the user's access key and secret to ~/.aws/credentials file under a profile like so:

```
[PROFILE_NAME]
aws_access_key_id=********************
aws_secret_access_key=****************************************
```

2. Create the S3 bucket through which you will store the Terraform configuration.
In `main.tf`, set the value of `<BUCKET_NAME>` to be the name of the bucket you created.
Also fill in the `<STATE_FILE_NAME>` (can be anything you want) and `<REGION>` (the region the state bucket is in) variables appropriately.

3. Give the IAM user you created in step 1 administrative access to the S3 bucket (either by directly attaching a policy or through a group). Use this policy template as an example:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListObjects",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::<BUCKET_NAME>",
                "arn:aws:s3:::<BUCKET_NAME>/*"
            ]
        }
    ]
}
```

4. Create a role with access to resources that you want Terraform modify. Note that this role must at least be able to access the state bucket you created in step 3. Set the variable `terraform_role_name` in `terraform.tfvars` to the name of this role. Also fill in the `aws_region` and `account_id` variables appropriately.

5. Set the AWS profile you want to use and initialise Terraform by running the following commands:

```bash
export AWS_PROFILE=PROFILE_NAME
terraform init
```
