provider "aws" {
  region = "ap-southeast-1"
}

variable "ssh_public_key" {
  type = string
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-rt"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name        = "hello-world-sg"
  description = "Security group for Hello World service"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting to your IP
  }

  ingress {
    description = "Hello World Service"
    from_port   = 4444
    to_port     = 4444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hello-world-sg"
  }
}

resource "aws_key_pair" "main" {
  key_name   = "tmp-ec2-sg-2025"
  public_key = var.ssh_public_key
}

resource "aws_instance" "main" {
  ami           = "ami-05f071c65e32875a8"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = aws_key_pair.main.key_name

  user_data = <<-EOF
              #!/bin/bash
              set -e
              
              # Install netcat
              dnf install -y nmap-ncat
              
              # Create systemd service
              cat > /etc/systemd/system/helloworld.service <<'SERVICE'
              [Unit]
              Description=Hello World Service on port 4444
              After=network.target
              
              [Service]
              Type=simple
              Restart=always
              RestartSec=5
              ExecStart=/bin/bash -c 'while true; do echo -e "HTTP/1.1 200 OK\r\n\r\nHello World from EC2" | nc -l -p 4444; done'
              
              [Install]
              WantedBy=multi-user.target
              SERVICE
              
              # Enable and start service
              systemctl daemon-reload
              systemctl enable helloworld.service
              systemctl start helloworld.service
              EOF

  tags = {
    Name = "HelloWorld"
  }
}

output "public_ip" {
  value       = aws_instance.main.public_ip
  description = "Public IP address of the EC2 instance"
}

output "service_url" {
  value       = "http://${aws_instance.main.public_ip}:4444"
  description = "URL to access the Hello World service"
}