# The CSI EBS driver policy.
resource "aws_iam_policy" "eks_csi_ebs_driver" {
  name                      = "AmazonEksCsiEbsDriver"

  policy                    = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
        ],
        Resource = "*"
      }
    ]
  })
}

# The CSI EBS driver role.
resource "aws_iam_role" "eks_csi_ebs_driver" {
  name                      = "AmazonEksCsiEbsDriver"

  assume_role_policy        = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/${local.eks_oidc}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.eks_oidc}:aud" = "sts.amazonaws.com"
            "${local.eks_oidc}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

# The policy attachment.
resource "aws_iam_role_policy_attachment" "eks_csi_ebs_driver" {
  role                      = aws_iam_role.eks_csi_ebs_driver.name
  policy_arn                = aws_iam_policy.eks_csi_ebs_driver.arn
}

# The CSI EBS driver chart.
resource "helm_release" "aws_ebs_csi_driver" {
  name                      = "aws-ebs-csi-driver"
  repository                = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart                     = "aws-ebs-csi-driver"
  namespace                 = "kube-system"
}

# Annotate the CSI service account, effectively authorizing the account to do the things specified in the policy.
resource "kubernetes_annotations" "ebs_csi_controller_sa" {
  api_version               = "v1"
  kind                      = "ServiceAccount"
  metadata {
    name                    = "ebs-csi-controller-sa"
    namespace               = "kube-system"
  }
  annotations = {
    "eks.amazonaws.com/role-arn"    = aws_iam_role.eks_csi_ebs_driver.arn
  }
  depends_on                = [helm_release.aws_ebs_csi_driver]
}
