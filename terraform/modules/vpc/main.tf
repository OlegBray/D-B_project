resource "aws_vpc" "oleg_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "oleg-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.oleg_vpc.id
  cidr_block              = var.public_subnets[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-oleg-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.oleg_vpc.id
  cidr_block              = var.public_subnets[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-oleg-2"
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.oleg_vpc.id
  cidr_block        = var.private_subnets[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "private-oleg-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.oleg_vpc.id
  cidr_block        = var.private_subnets[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "private-oleg-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.oleg_vpc.id

  tags = {
    Name = "oleg-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.oleg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}
