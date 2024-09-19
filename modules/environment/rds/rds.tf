resource "aws_db_instance" "_" {
  identifier                = "rds-${var.environment}"
  instance_class            = "db.t3.medium"
  allocated_storage         = 70
  engine                    = "postgres"
  engine_version            = "13.7"
  username                  = var.master_username
  password                  = var.master_password
  db_subnet_group_name      = aws_db_subnet_group._.name
  vpc_security_group_ids    = [aws_security_group._.id]
  parameter_group_name      = aws_db_parameter_group._.name
  publicly_accessible       = false
  skip_final_snapshot       = true
  backup_retention_period   = 7
  storage_encrypted         = true
  deletion_protection       = true
  tags = {
    "Name"                  = "rds-${var.environment}"
  }
}
