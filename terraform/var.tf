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
  default     = "oleg-key"
}

variable "node_instance_role_name" {
  description = "IAM role name attached to your RKE2 EC2 instances"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the cluster and ALB"
  type        = string
}

variable "nodeport" {
  description = "NodePort that your Kubernetes Service exposes"
  type        = number
}

variable "target_ips" {
  description = "Map of identifier→IP of each RKE2 node (in private subnets)"
  type        = map(string)
}