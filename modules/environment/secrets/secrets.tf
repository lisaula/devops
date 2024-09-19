resource "random_password" "rds" {
  length                    = 25
  special                   = false
}

resource "aws_secretsmanager_secret" "rds" {
  name                      = "rds-${var.environment}"
}


resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = <<EOF
{
  "username": "${var.master_username}",
  "password": "${random_password.rds.result}",
  "engine": "pgsql",
  "host": "${var.endpoint}",
  "port": ${var.port}
}
EOF
}
