variable "user_name" {
  description = "The name of the service user to create (automatically prefixed by 's3site.deployer-')"
}

variable "bucket_name" {
  description	= "The name of the website bucket to give the service user access to"
}
