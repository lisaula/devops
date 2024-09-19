module "load_balancer_controller" {
  source                            = "git::https://github.com/DNXLabs/terraform-aws-eks-lb-controller.git"

  cluster_name                      = var.cluster.name
  cluster_identity_oidc_issuer      = local.eks_oidc
  cluster_identity_oidc_issuer_arn  = "arn:aws:iam::${local.account_id}:oidc-provider/${local.eks_oidc}"
}
