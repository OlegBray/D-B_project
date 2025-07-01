output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_instance_ids" {
  value = module.instances.public_instance_ids
}

output "private_instance_ids" {
  value = module.instances.private_instance_ids
}
