resource "aws_security_group" "_" {
  name                      = "elasticache-${var.environment}"
  vpc_id                    = var.vpc_id

  ingress {
    from_port               = 6379
    to_port                 = 6379
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }
  egress {
    from_port               = 6379
    to_port                 = 6379
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  tags = {
    Name                    = "elasticache-${var.environment}"
  }
}
