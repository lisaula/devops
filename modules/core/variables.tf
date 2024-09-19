variable "cluster_name" {}
variable "kubernetes_version" {}
variable "subnet_ids" {
  type                      = list(string)
}
