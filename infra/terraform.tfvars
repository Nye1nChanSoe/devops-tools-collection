aws_region        = "ap-southeast-7"
project_name      = "hs-devops-2025"
environment       = "testing"
availability_zone = "ap-southeast-7a"

vpc_name    = "hs-devops-vpc"
vpc_cidr    = "10.0.0.0/16"
subnet_name = "hs-devops-subnet"
subnet_cidr = "10.0.1.0/24"

ami_id         = "ami-0940ccc74896086cc"
instance_type  = "t3.micro"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEb8B1PPdqBp/RQe/uVoKAmg02JVih2fFQkBSyeLC/8k nyeinchansoe.business@gmail.com"
allowed_ssh_cidr = "0.0.0.0/0"