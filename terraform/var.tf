variable "region" {
  default = "eu-central-1"
}

variable "vpc_cidr" {
  default = "172.10.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["172.10.100.0/24", "172.10.110.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["172.10.20.0/24", "172.10.30.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "ami_id" {
  default = "ami-02003f9f0fde924ea"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "public_instance_count" {
  default = 1
}

variable "private_instance_count" {
  default = 3
}

variable "key_name" {
  description = "Name of the SSH key"
  type        = string
  default     = "oleg"
}

variable "public_key_path" {
  description   = "Path to the public key file"
  type          = string
  default       = "/home/oleg/.ssh/id_rsa.pub"
}
