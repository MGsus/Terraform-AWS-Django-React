# VPC
resource "aws_vpc" "test-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "Test-VPC"
  }
}

# Subnet
resource "aws_subnet" "subnet" {
  cidr_block              = var.subnet_cidr
  vpc_id                  = aws_vpc.test-vpc.id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "test-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "test-ig" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    Name = "test-ig"
  }
}

# Route table
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-ig.id
  }
  tags = {
    Name = "test-rt"
  }
}

resource "aws_route_table_association" "route-as" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route-table.id
}
