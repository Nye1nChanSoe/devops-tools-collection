provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name          = var.vpc_name
  vpc_cidr          = var.vpc_cidr
  subnet_name       = var.subnet_name
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone

  project_name = var.project_name
  environment  = var.environment
}

module "ec2" {
  source = "./modules/ec2"

  name           = "${var.project_name}-${var.environment}"
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  ssh_public_key = var.ssh_public_key

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id

  allowed_ssh_cidr = var.allowed_ssh_cidr

  project_name = var.project_name
  environment  = var.environment
}