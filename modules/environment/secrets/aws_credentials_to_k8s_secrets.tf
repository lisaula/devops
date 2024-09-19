resource "kubernetes_namespace" "_" {
  metadata {
    name                    = "tla-${var.environment}"
  }
}

resource "kubernetes_secret" "rds_credentials_to_k8s_secret" {
  metadata {
    name                    = "aws-rds-credentials"
    namespace               = "tla-${var.environment}"
  }

  data = {
    endpoint                = var.aws_rds_endpoint
    user                    = var.aws_rds_user
    password                = random_password.rds.result
  }

  depends_on                = [kubernetes_namespace._]
}

resource "kubernetes_secret" "efs_credentials_to_k8s_secret" {
  metadata {
    name                    = "aws-efs-credentials"
    namespace               = "tla-${var.environment}"
  }

  data = {
    efsdnsname               = var.aws_efs_target
    efsid                    = var.efs_id
    sapid                    = var.sap_id
    user                     = ""
    password                 = ""
  }

  depends_on                = [kubernetes_namespace._]
}

resource "kubernetes_secret" "redis_url_to_k8s_secret" {
  metadata {
    name                    = "aws-elasticache-credentials"
    namespace               = "tla-${var.environment}"
  }

  data = {
    redis_url               = "redis://${var.redis_endpoint}:${var.redis_port}/0"
  }

  depends_on                = [kubernetes_namespace._]
}
