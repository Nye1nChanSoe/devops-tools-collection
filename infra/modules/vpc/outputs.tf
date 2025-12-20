output "vpc_id" {
  value = aws_vpc.this.id
  description = "VPC ID"
}

output "subnet_id" {
  value = aws_subnet.this.id
  description = "Subnet ID"
}