output "arn" {
  value = "${aws_iam_user.deployment-user.arn}"
}

output "name" {
  value = "${aws_iam_user.deployment-user.name}"
}
