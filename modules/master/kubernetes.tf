data "aws_eks_cluster_auth" "_" {
  name                      = var.cluster.id
}

provider "kubernetes" {
  host                      = var.cluster.endpoint
  cluster_ca_certificate    = base64decode(var.cluster.certificate_authority[0].data)
  token                     = data.aws_eks_cluster_auth._.token
}

provider "helm" {
  kubernetes {
    host                    = var.cluster.endpoint
    cluster_ca_certificate  = base64decode(var.cluster.certificate_authority[0].data)
    token                   = data.aws_eks_cluster_auth._.token
  }
}
