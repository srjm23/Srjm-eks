resource "aws_vpc" "eks" {

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  enable_dns_support = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }

}

resource "aws_subnet" "public_a" {

  vpc_id = aws_vpc.eks.id

  cidr_block = var.public_subnets[0]

  availability_zone = var.availability_zones[0]

  map_public_ip_on_launch = true

  tags = {

    Name = "${var.cluster_name}-public-2a"

    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    "kubernetes.io/role/elb" = "1"

  }

}

resource "aws_subnet" "public_b" {

  vpc_id = aws_vpc.eks.id

  cidr_block = var.public_subnets[1]

  availability_zone = var.availability_zones[1]

  map_public_ip_on_launch = true

  tags = {

    Name = "${var.cluster_name}-public-2b"

    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    "kubernetes.io/role/elb" = "1"

  }

}

resource "aws_subnet" "private_a" {

  vpc_id = aws_vpc.eks.id

  cidr_block = var.private_subnets[0]

  availability_zone = var.availability_zones[0]

  tags = {

    Name = "${var.cluster_name}-private-2a"

    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    "kubernetes.io/role/internal-elb" = "1"

  }

}


resource "aws_subnet" "private_b" {

  vpc_id = aws_vpc.eks.id

  cidr_block = var.private_subnets[1]

  availability_zone = var.availability_zones[1]

  tags = {

    Name = "${var.cluster_name}-private-2b"

    "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    "kubernetes.io/role/internal-elb" = "1"

  }

}


resource "aws_internet_gateway" "eks" {

  vpc_id = aws_vpc.eks.id

  tags = {

    Name = "${var.cluster_name}-igw"

  }

}

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {

    Name = "${var.cluster_name}-nat-eip"

  }

}

resource "aws_nat_gateway" "eks" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_a.id

  depends_on = [

    aws_internet_gateway.eks

  ]

  tags = {

    Name = "${var.cluster_name}-nat"

  }

}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.eks.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.eks.id

  }

}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.eks.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.eks.id

  }

}

resource "aws_route_table_association" "public_a" {

  subnet_id = aws_subnet.public_a.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_b" {

  subnet_id = aws_subnet.public_b.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private_a" {

  subnet_id = aws_subnet.private_a.id

  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_b" {

  subnet_id = aws_subnet.private_b.id

  route_table_id = aws_route_table.private.id

}
