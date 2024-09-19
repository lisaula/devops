resource "aws_launch_template" "_" {
  name                      = "default"

  block_device_mappings {
    device_name             = "/dev/xvda"

    ebs {
      volume_size           = var.size_disk
    }
  }

  metadata_options {
    http_endpoint           = "enabled"
    http_tokens             = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags  = "enabled"
  }
}

resource "aws_eks_node_group" "_" {
  for_each                  = toset(var.instance_types)

  cluster_name              = var.cluster.name
  node_group_name           = "nodes-${replace(each.key, ".", "-")}"
  node_role_arn             = aws_iam_role.aws_eks_node_group.arn

  subnet_ids                = var.subnet_ids

  capacity_type             = "ON_DEMAND"
  instance_types            = [each.key]
  ami_type                  = var.ami_type

  scaling_config {
    desired_size            = var.desired_size
    max_size                = var.max_size
    min_size                = var.min_size
  }

  update_config {
    max_unavailable         = 1
  }

  launch_template {
    id                      = aws_launch_template._.id
    version                 = aws_launch_template._.latest_version
  }

  labels = {
    role                    = "general"
  }

  depends_on                = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    ignore_changes          = [
      # The Kubernetes autoscaler may adjust this up and down.
      scaling_config[0].desired_size
    ]
  }
}
