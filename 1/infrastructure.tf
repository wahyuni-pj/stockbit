resource "aws_vpc" "develop" {
  cidr_block           = "10.0.0.0/16"
  tags = {
    Environment = "develop"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.develop.id
  tags = {
    Environment = "develop"
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Environment = "develop"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.develop.id
  cidr_block              = "10.0.2.0/24"
  tags = {
    Environment = "develop"
    Access      = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.develop.id
  cidr_block              = "10.0.1.0/24"
  tags = {
    Environment = "develop"
    Access      = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.develop.id
  tags = {
    Environment = "develop"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.develop.id
  tags = {
    Environment = "develop"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_internet_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
