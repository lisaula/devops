resource "aws_efs_access_point" "_" {
  tags = {
    Name                    = "ap-${var.environment}"
  }

  file_system_id            = var.efs.id

  root_directory {
    path                    = "/shared-${var.environment}"

    creation_info {
      owner_gid             = 0
      owner_uid             = 0
      permissions           = "0755"
    }
  }
}
