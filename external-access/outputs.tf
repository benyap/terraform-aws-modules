output "role_arn" {
  value = "${aws_iam_role.external-role.arn}"
}

output "role_name" {
  value = "${aws_iam_role.external-role.name}"
}

output "role_unique_id" {
  value = "${aws_iam_role.external-role.unique_id}"
}

output "role_description" {
  value = "${aws_iam_role.external-role.description}"
}

output "role_create_date" {
  value = "${aws_iam_role.external-role.create_date}"
}
