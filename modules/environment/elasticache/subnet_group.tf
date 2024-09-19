resource "aws_elasticache_subnet_group" "_" {
  name                      = "elasticache-${var.environment}"
  subnet_ids                = var.subnet_ids
  tags                      = {
    name                    = "elasticache-${var.environment}"
  }
}
