output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "public_url" {
  value = module.ec2.public_url
}

output "service_urk" {
  value = module.ec2.service_url
}