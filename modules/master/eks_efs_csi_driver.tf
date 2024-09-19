# The CSI EFS driver policy.
resource "aws_iam_policy" "eks_csi_efs_driver" {
  name                      = "AmazonEksCsiEfsDriver"
  policy                    = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "ec2:DescribeAvailabilityZones"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "elasticfilesystem:CreateAccessPoint"
        ],
        Resource = "*",
        Condition = {
          StringLike = {
            "aws:RequestTag/efs.csi.aws.com/cluster" = "true"
          }
        }
      },
      {
        Effect = "Allow",
        Action = "elasticfilesystem:DeleteAccessPoint",
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:ResourceTag/efs.csi.aws.com/cluster" = "true"
          }
        }
      }
    ]
  })
}

# The CSI EFS driver role.
resource "aws_iam_role" "eks_csi_efs_driver" {
  name                      = "AmazonEksCsiEfsDriver"

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
            "${local.eks_oidc}:sub" = "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

# The policy attachment.
resource "aws_iam_role_policy_attachment" "eks_csi_efs_driver" {
  role                      = aws_iam_role.eks_csi_efs_driver.name
  policy_arn                = aws_iam_policy.eks_csi_efs_driver.arn
}

# The CSI EFS driver chart.
resource "helm_release" "aws_efs_csi_driver" {
  name                      = "aws-efs-csi-driver"
  repository                = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart                     = "aws-efs-csi-driver"
  namespace                 = "kube-system"
}

# Annotate the CSI service account, effectively authorizing the account to do the things specified in the policy.
resource "kubernetes_annotations" "efs_csi_controller_sa" {
  api_version               = "v1"
  kind                      = "ServiceAccount"
  metadata {
    name                    = "efs-csi-controller-sa"
    namespace               = "kube-system"
  }
  annotations = {
    "eks.amazonaws.com/role-arn"    = aws_iam_role.eks_csi_efs_driver.arn
  }
  depends_on                = [helm_release.aws_efs_csi_driver]
}
