resource "aws_efs_file_system" "efs" {
  performance_mode          = "generalPurpose"
  throughput_mode           = "bursting"

  lifecycle_policy {
    transition_to_ia        = "AFTER_30_DAYS"
  }

  tags                      = {
    Name                    = "EFS"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
  count                     = length(var.subnet_ids)
  file_system_id            = aws_efs_file_system.efs.id
  subnet_id                 = var.subnet_ids[count.index]
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id            = aws_efs_file_system.efs.id
  policy                    = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "PolicyEfs",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "elasticfilesystem:AccessedViaMountTarget": "true"
                }
            }
        }
    ]
}
POLICY
}
