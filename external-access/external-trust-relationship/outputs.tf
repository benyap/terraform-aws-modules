output "arn" {
  value = "${aws_iam_role.role.arn}"
}

output "name" {
  value = "${aws_iam_role.role.name}"
}

output "unique_id" {
  value = "${aws_iam_role.role.unique_id}"
}

output "description" {
  value = "${aws_iam_role.role.description}"
}

output "create_date" {
  value = "${aws_iam_role.role.create_date}"
}
