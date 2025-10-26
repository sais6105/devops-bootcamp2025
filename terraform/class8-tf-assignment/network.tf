resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = merge(
    local.common_tags,
  tomap({ "Name" = "${local.prefix}-vpc" }))
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = var.subnet_cidr_list[0]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${data.aws_region.current.name}a"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public" })
  )
}

resource "aws_subnet" "private_subnet1" {
  cidr_block        = var.subnet_cidr_list[1]
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-private1" })
  )
}

resource "aws_subnet" "private_subnet2" {
  cidr_block        = var.subnet_cidr_list[2]
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}b"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-private2" })
  )
}

# Internet gateway to enable trafic from internet
resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-main" })
  )
}


# Elastic IP

resource "aws_eip" "elastic_ip" {
  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public" })
  )
  depends_on = [aws_internet_gateway.igw_main]
}

# Nat Gateway in Public Subnet and association with EIP
resource "aws_nat_gateway" "nt_gw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public-a" })
  )
  depends_on = [aws_internet_gateway.igw_main]

}

# Public Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main.id
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public" })
  )
}

# Private Route table1

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nt_gw.id
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public" })
  )

}

# public Route table association

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id


}

# Private1 Route table association
resource "aws_route_table_association" "private_rta1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id

}

# Private2 Route table association
resource "aws_route_table_association" "private_rta2" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet2.id

}



# # Private subnet Outbound Internet - Route 
# resource "aws_route" "private_outbound" {
#   route_table_id         = aws_route_table.private_rt.id
#   nat_gateway_id         = aws_nat_gateway.nt_gw.id
#   destination_cidr_block = "0.0.0.0/0"

# }

# #Public Subnet Internet access  - Route
# resource "aws_route" "public_internet_access" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw_main.id


# }