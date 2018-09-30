output "arn" {
  value = "${aws_iam_user.ses-user.arn}"
}

output "name" {
  value = "${aws_iam_user.ses-user.name}"
}
