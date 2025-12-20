variable "project_name" {
  type = string
  description = "Project name"
}

variable "environment" {
  type = string
  description = "Project Environment"
}

variable "name" {
  type = string
  description = "Name prefix for EC2 resources"
}

variable "ami_id" {
  type = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type = string
  description = "EC2 instance type"
}

variable "subnet_id" {
  type = string
  description = "Subnet ID"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "ssh_public_key" {
  type = string
  description = "Public SSH key"
}

variable "allowed_ssh_cidr" {
  type = string
  description = "CIDR blocks allowed to SSH"
}