resource "aws_iam_user" "developer" {
  name = "jm-dev"
}

resource "aws_eks_access_entry" "developer" {
  cluster_name      = aws_eks_cluster.srjm-eks.name
  principal_arn     = aws_iam_user.developer.arn
  kubernetes_groups = ["developers"]
}

resource "aws_iam_user_policy" "jm_dev_eks" {
  name = "jm-dev-eks-access"
  user = aws_iam_user.developer.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = "arn:aws:eks:${var.aws_region}:${var.account_id}:cluster/${var.cluster_name}"
      }
    ]
  })
}