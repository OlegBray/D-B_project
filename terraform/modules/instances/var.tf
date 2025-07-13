variable "ami_id" {}
variable "instance_type" {}
variable "public_instance_count" {}
variable "private_instance_count" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "vpc_id" {}

variable "key_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}