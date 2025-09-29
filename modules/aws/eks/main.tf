data "aws_partition" "this" {}
data "aws_caller_identity" "current" {}

# IAM role for EKS control plane
resource "aws_iam_role" "eks" {
  name = "${var.name}-control-plane"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "eks.${data.aws_partition.this.dns_suffix}" },
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:${data.aws_partition.this.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Security group for the cluster
resource "aws_security_group" "cluster" {
  name        = "${var.name}-sg"
  description = "EKS cluster SG"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

# Optional KMS key for secrets encryption
resource "aws_kms_key" "eks_secrets" {
  count               = var.enable_secrets_encryption && var.kms_key_arn == null ? 1 : 0
  description         = "KMS key for ${var.name} EKS secrets encryption"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "EnableRoot",
        Effect : "Allow",
        Principal : {
          AWS : "arn:${data.aws_partition.this.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      }
    ]
  })

  tags = var.tags
}

# EKS cluster
resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = aws_iam_role.eks.arn
  version  = var.kubernetes_version

  vpc_config {
    # CKV_AWS_39 / CKV_AWS_38
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access ? var.public_access_cidrs : []

    security_group_ids = [aws_security_group.cluster.id]
    subnet_ids         = var.private_subnet_ids
  }

  # CKV_AWS_37: enable control plane logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # CKV_AWS_58: secrets encryption with KMS
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.eks_secrets
    }
  }

  tags = var.tags
}

# OIDC provider for IRSA
data "tls_certificate" "oidc" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
  tags            = var.tags
}
