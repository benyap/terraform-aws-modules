variable "account_id" {
  description = "The account ID"
}

variable "role_name" {
  description = "The name of the role to assume to create the ACM certificate"
}

variable domain_name {
  description = "The name of the domain for this record"
}

variable hosted_zone_id {
  description = "The ID of the hosted zone in which the domain record is in"
}
