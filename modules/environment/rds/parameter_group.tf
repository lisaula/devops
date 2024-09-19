resource "aws_db_parameter_group" "_" {
  name                      = "rds-${var.environment}"
  family                    = "postgres13"

  parameter {
    name                    = "log_connections"
    value                   = "1"
  }
  tags = {
    "Name"                  = "rds-${var.environment}"
  }
}
