resource "aws_eks_cluster" "_" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_cluster.arn
  version                   = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
  }

  depends_on                = [aws_iam_role_policy_attachment.eks_cluster]
}
