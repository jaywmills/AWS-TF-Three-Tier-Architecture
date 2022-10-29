# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

data "aws_availability_zones" "available" {
}


resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = 2
}

resource "aws_subnet" "public_project_subnet" {
  count             = var.public_sn_count
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "project public ${count.index}"
  }
}

resource "aws_subnet" "private_project_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "project private ${count.index}"
  }
}

resource "aws_subnet" "private_project_subnet_app" {
  count             = var.app_tier_sn_count
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.app_tier_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "project app tier ${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "IGW"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "Private_Route_Table"
  }
}

# Route Table association with Subnet
resource "aws_route_table_association" "public" {
  count = var.public_sn_count
  subnet_id      = aws_subnet.public_project_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table association with Subnet
resource "aws_route_table_association" "default" {
  count = var.private_sn_count
  subnet_id      = aws_subnet.public_project_subnet[count.index].id
  route_table_id = aws_route_table.public.id 
}
resource "aws_route_table_association" "app_tier" {
  count = var.app_tier_sn_count
  subnet_id = aws_subnet.private_project_subnet_app[count.index].id
  route_table_id = aws_default_route_table.private.id
}

resource "aws_eip" "elastic_ip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_project_subnet[0].id

  tags = {
    Name = "NAT_GW"
  }

  depends_on = [aws_internet_gateway.igw]
}