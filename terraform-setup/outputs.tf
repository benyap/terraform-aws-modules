output "terraform_role_arn" {
  value = "${aws_iam_role.terraform-role.arn}"
}

output "terraform_role_name" {
  value = "${aws_iam_role.terraform-role.name}"
}

output "terraform_role_unique_id" {
  value = "${aws_iam_role.terraform-role.unique_id}"
}

output "terraform_role_description" {
  value = "${aws_iam_role.terraform-role.description}"
}

output "terraform_role_create_date" {
  value = "${aws_iam_role.terraform-role.create_date}"
}
