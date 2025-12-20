output "public_ip" {
  value = aws_instance.this.public_ip
  description = "Public IP of the EC2 instance"
}

output "service_url" {
  value = "https://${aws_instance.this.public_ip}:4444"
  description = "Web service url"
}