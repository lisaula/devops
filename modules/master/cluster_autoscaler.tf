module "cluster_autoscaler" {
  source                            = "git::https://github.com/scalient/terraform-aws-eks-cluster-autoscaler.git"

  enabled = true

  cluster_name                      = var.cluster.name
  cluster_identity_oidc_issuer      = local.eks_oidc
  cluster_identity_oidc_issuer_arn  = "arn:aws:iam::${local.account_id}:oidc-provider/${local.eks_oidc}"
  aws_region                        = data.aws_region.current.name
}
