resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[0]
  map_public_ip_on_launch = true

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "tf-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[1]
  map_public_ip_on_launch = true

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "tf-public-subnet-2"
  }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[0]

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "tf-private-subnet-1"
  }
}


resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[1]

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "tf-private-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-igw"
  }
}


# elastic ip
resource "aws_eip" "nat" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat.id

#   subnet_id = aws_subnet.public_subnet_1.id

#   tags = {
#     Name = "tf-NAT-GW"
#   }
# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "tf-rt-public"
  }
}

# public subnet에 public route 할당
resource "aws_route_table_association" "route_table_association_public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-rt-private"
  }
}



resource "aws_route_table_association" "route_table_association_private_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "route_table_association_private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

# private route에 nat 라우팅 추가
# resource "aws_route" "private_nat" {
#   route_table_id              = aws_route_table.private.id
#   destination_cidr_block      = "0.0.0.0/0"
#   nat_gateway_id              = aws_nat_gateway.nat_gateway.id
# }