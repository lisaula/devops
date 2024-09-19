resource "aws_efs_access_point" "_" {
  tags = {
    Name                    = "ap-nexus"
  }

  file_system_id            = var.efs.id

  root_directory {
    path                    = "/k8s-nexus"

    creation_info {
      owner_gid             = 0
      owner_uid             = 0
      permissions           = "0755"
    }
  }
}

resource "kubernetes_namespace" "nexus" {
  metadata {
    name                    = "nexus"
  }
}

resource "kubernetes_persistent_volume" "nexus" {
  metadata {
    name                    = "efs-nexus"
  }

  spec {
    access_modes            = ["ReadWriteMany"]
    storage_class_name      = "efs-sc"
    capacity                = {
      storage               = "16Gi"
    }
    mount_options           = ["iam"]

    persistent_volume_source {
      csi {
        driver              = "efs.csi.aws.com"
        # Note the special syntax for locating an EFS access point.
        volume_handle       = "${var.efs.id}::${aws_efs_access_point._.id}"
      }
    }
  }

  depends_on                = [kubernetes_storage_class.efs-sc, aws_efs_access_point._]
}

resource "kubernetes_persistent_volume_claim" "nexus" {
  metadata {
    name                    = "nexus"
    namespace               = "nexus"
  }

  spec {
    access_modes            = ["ReadWriteMany"]
    storage_class_name      = "efs-sc"
    volume_name             = "efs-nexus"

    resources {
      requests = {
        storage             = "16Gi"
      }
    }
  }

  wait_until_bound          = false

  depends_on                = [kubernetes_namespace.nexus, kubernetes_persistent_volume.nexus]
}

# The Nexus OSS server chart.
resource "helm_release" "nexus" {
  name                      = "nexus"
  repository                = "https://sonatype.github.io/helm3-charts"
  chart                     = "nexus-repository-manager"
  namespace                 = "nexus"

  set {
    name                    = "persistence.existingClaim"
    value                   = "nexus"
  }

  depends_on                = [kubernetes_namespace.nexus, kubernetes_persistent_volume_claim.nexus]
}
