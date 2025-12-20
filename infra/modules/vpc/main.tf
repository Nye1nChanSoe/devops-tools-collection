resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name: var.vpc_name
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "this" {
  # assign by aws
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name: var.subnet_name
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "terraform"
  }
}

# igw for public ec2 inside vpc
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id


  tags = {
    Name: "${var.vpc_name}-igw"
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "terraform"
  }  
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    # internet traffic - igw
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name: "${var.vpc_name}-rt"
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "terraform"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}
