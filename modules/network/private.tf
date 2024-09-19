resource "aws_subnet" "private-us-east-1a" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.private_subnet_1a
  availability_zone         = var.region_1_a

  tags = {
    "Name"                  = "${var.cluster_name}-private-${var.region_1_a}"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.private_subnet_1b
  availability_zone         = var.region_1_b

  tags = {
    "Name"                  = "${var.cluster_name}-private-${var.region_1_b}"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-us-east-1c" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.private_subnet_1c
  availability_zone         = var.region_1_c

  tags = {
    "Name"                  = "${var.cluster_name}-private-${var.region_1_c}"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
