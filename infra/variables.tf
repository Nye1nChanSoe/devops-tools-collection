variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Project Environment"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "subnet_name" {
  type        = string
  description = "Name of VPC Subnets"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the subnet"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for aws instances"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH into EC2 from Jenkins"
  sensitive = true
}

variable "allowed_ssh_cidr" {
  type = string
  description = "CIDR blocks allowed to SSH"
}