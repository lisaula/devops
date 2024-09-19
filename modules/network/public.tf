resource "aws_subnet" "public-us-east-1a" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.public_subnet_1a
  availability_zone         = var.region_1_a

  map_public_ip_on_launch   = true

  tags = {
    "Name"                   = "${var.cluster_name}-public-${var.region_1_a}"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.public_subnet_1b
  availability_zone         = var.region_1_b

  map_public_ip_on_launch   = true

  tags = {
    "Name"                  = "${var.cluster_name}-public-${var.region_1_b}"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
resource "aws_subnet" "public-us-east-1c" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.public_subnet_1c
  availability_zone         = var.region_1_c

  map_public_ip_on_launch   = true

  tags = {
    "Name"                  = "${var.cluster_name}-public-${var.region_1_c}"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
