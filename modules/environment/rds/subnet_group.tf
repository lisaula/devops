resource "aws_db_subnet_group" "_" {
  name                      = "rds-${var.environment}"
  subnet_ids                = var.subnet_ids
  tags = {
    Name                    = "rds-${var.environment}"
  }
}
