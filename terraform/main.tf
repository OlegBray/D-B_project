provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "instances" {
  source = "./modules/instances"

  ami_id                  = var.ami_id
  key_name                = var.key_name
  public_key_path         = var.public_key_path
  instance_type           = var.instance_type
  public_instance_count   = var.public_instance_count
  private_instance_count  = var.private_instance_count
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_subnet_ids      = module.vpc.private_subnet_ids
  vpc_id                  = module.vpc.vpc_id
}
