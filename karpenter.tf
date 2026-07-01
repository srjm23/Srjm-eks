resource "aws_iam_role" "karpenter" {
  name               = "karpenter-role"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume.json
}

resource "aws_iam_role_policy_attachment" "karpenter" {
  role       = aws_iam_role.karpenter.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  namespace  = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"

  create_namespace = true

  depends_on = [
    aws_iam_role_policy_attachment.karpenter,
    aws_iam_role.karpenter,
    aws_iam_openid_connect_provider.eks
  ]
}