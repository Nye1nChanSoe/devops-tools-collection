resource "aws_security_group" "this" {
  name = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id = var.vpc_id

  # entering
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # web service
  ingress {
    description = "Web Service"
    from_port = 4444
    to_port = 4444
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # exiting
  egress {
    description = "Allow all outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name: "${var.name}-sg"
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "terraform"
  }
}

# let EC2 add pub key to  ~/.ssh/authorized_keys at launch
resource "aws_key_pair" "this" {
  key_name = "${var.name}-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "this" {
  ami = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id
  security_groups = [aws_security_group.this.id]
  key_name = aws_key_pair.this.key_name

  tags = {
    Name: var.name
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "terraform"
  }
}