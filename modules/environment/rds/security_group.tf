resource "aws_security_group" "_" {
  name                      = "rds-${var.environment}"
  vpc_id                    = var.vpc_id

  ingress {
    from_port               = 5432
    to_port                 = 5432
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }
  egress {
    from_port               = 5432
    to_port                 = 5432
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  tags = {
    Name                    = "rds-${var.environment}"
  }
}
