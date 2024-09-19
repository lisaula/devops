resource "kubernetes_namespace" "argocd" {
  metadata {
    name                    = "argocd"
  }
}

# The Argo CD chart.
resource "helm_release" "argocd" {
  name                      = "argocd"
  repository                = "https://argoproj.github.io/argo-helm"
  chart                     = "argo-cd"
  namespace                 = "argocd"

  set {
    name                    = "configs.params.server\\.insecure"
    value                   = true
  }

  depends_on                = [kubernetes_namespace.argocd]
}
