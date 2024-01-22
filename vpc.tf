resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(var.common_tags,
    {
      "Name"                                                                 = "${var.project_name}-${var.environmnet}-vpc",
      "kubernetes.io/cluster/${var.project_name}-${var.environmnet}-cluster" = "owned"
    }
  )

}

resource "aws_subnet" "publicsubnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.common_tags,
    {
      "Name"                                                                 = "${var.project_name}-${var.environmnet}-vpc-publicsubent-${count.index + 1}",
      "kubernetes.io/cluster/${var.project_name}-${var.environmnet}-cluster" = "owned"
      "kubernetes.io/role/elb"                                               = "1"
    }
  )
}


resource "aws_subnet" "privatesubents" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
  tags = merge(var.common_tags,
    {
      "Name"                                                                 = "${var.project_name}-${var.environmnet}-vpc-privatesubent-${count.index + 1}",
      "kubernetes.io/cluster/${var.project_name}-${var.environmnet}-cluster" = "owned"
      "kubernetes.io/role/internal-elb	"                                     = "1"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-vpc-igw"
  })
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-vpc-publicrt"
  })
}

resource "aws_route_table_association" "publicrtassoication" {
  count          = length(var.public_subnets_cidr)
  route_table_id = aws_route_table.publicrt.id
  subnet_id      = aws_subnet.publicsubnets[count.index].id
}


resource "aws_eip" "eips" {
  count  = length(var.public_subnets_cidr)
  domain = "vpc"
  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "natgateways" {
  count         = length(var.public_subnets_cidr)
  allocation_id = aws_eip.eips[count.index].id
  subnet_id     = aws_subnet.publicsubnets[count.index].id
  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-vpc-nat-${count.index + 1}"
  })
  depends_on = [aws_internet_gateway.main]
}


resource "aws_route_table" "privatert" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateways[count.index].id
  }
  tags = merge(var.common_tags,
    {
      "Name" = "${var.project_name}-${var.environmnet}-vpc-privatert-${count.index + 1}"
  })
}

resource "aws_route_table_association" "privatertassociations" {
  count          = length(var.private_subnets_cidr)
  route_table_id = aws_route_table.privatert[count.index].id
  subnet_id      = aws_subnet.privatesubents[count.index].id
}