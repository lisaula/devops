resource "kubernetes_storage_class" "ebs-sc" {
  metadata {
    name                    = "ebs-sc"
  }

  storage_provisioner       = "ebs.csi.aws.com"
  reclaim_policy            = "Delete"
  volume_binding_mode       = "WaitForFirstConsumer"

  depends_on                = [helm_release.aws_ebs_csi_driver]
}

resource "kubernetes_storage_class" "efs-sc" {
  metadata {
    name                    = "efs-sc"
  }

  storage_provisioner       = "efs.csi.aws.com"
  reclaim_policy            = "Delete"
  volume_binding_mode       = "Immediate"

  depends_on                = [helm_release.aws_efs_csi_driver]
}
