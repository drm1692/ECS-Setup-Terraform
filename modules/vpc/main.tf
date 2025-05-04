resource "aws_vpc" "prefect-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = var.common_tags
}

resource "aws_subnet" "public" {

  count                   = length(var.cidr_public_subnet)
  vpc_id                  = aws_vpc.prefect-vpc.id
  cidr_block              = element(var.cidr_public_subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {

  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.prefect-vpc.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "${var.vpc_name}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prefect-vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${var.vpc_name}-nat"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.prefect-vpc.id
  tags = {
    Name = "${var.vpc_name}-publicRT"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.cidr_public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.prefect-vpc.id
  tags = {
    Name = "${var.vpc_name}-privateRT"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.cidr_private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
