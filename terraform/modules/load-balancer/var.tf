variable "target_ips" {
  type        = map(string)
  description = "Map of names to private IPs of target instances"
}

variable "public_subnet_ids" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "nodeport" {
  description = "NodePort of your Kubernetes Service"
  type        = number
}
