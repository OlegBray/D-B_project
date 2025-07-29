output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_instance_ids" {
  value = module.instances.public_instance_ids
}

output "private_instance_ids" {
  value = module.instances.private_instance_ids
}

output "alb_controller_policy_arn" {
  description = "The ARN of the IAM policy attached to your node role"
  value       = module.alb_iam.alb_policy_arn
}

output "alb_dns_name" {
  description = "The DNS name of the newly created ALB"
  value       = module.load_balancer.alb_dns_name
}