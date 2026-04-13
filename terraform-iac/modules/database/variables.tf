variable "subnet_id" {}

variable "security_group" {}

variable "db_password" {
  sensitive = true
}
