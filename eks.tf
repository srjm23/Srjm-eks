resource "aws_eks_cluster" "srjm-eks" {

  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster.arn

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_config {

    subnet_ids = [

      aws_subnet.private_a.id,
      aws_subnet.private_b.id,

      aws_subnet.public_a.id,
      aws_subnet.public_b.id

    ]

    endpoint_private_access = true

    endpoint_public_access = true

    security_group_ids = [

      aws_security_group.eks_cluster.id

    ]

  }

  depends_on = [

    aws_iam_role_policy_attachment.cluster_policy

  ]

  tags = local.common_tags

}

resource "aws_eks_node_group" "workers" {

  cluster_name = aws_eks_cluster.srjm-eks.name

  node_group_name = "managed-workers"

  node_role_arn = aws_iam_role.eks_nodes.arn

  subnet_ids = [

    aws_subnet.private_a.id,

    aws_subnet.private_b.id,

  ]

  instance_types = [var.node_instance_type]


  capacity_type = "SPOT"

  scaling_config {

    desired_size = var.desired_nodes

    min_size = var.min_nodes

    max_size = var.max_nodes

  }

  update_config {

    max_unavailable = 1

  }

  depends_on = [

    aws_iam_role_policy_attachment.worker_node,

    aws_iam_role_policy_attachment.cni,

    aws_iam_role_policy_attachment.ssm,

    aws_iam_role_policy_attachment.ecr

  ]

  tags = local.common_tags

}

resource "aws_eks_addon" "vpc_cni" {

  cluster_name  = aws_eks_cluster.srjm-eks.name
  addon_version = data.aws_eks_addon_version.vpc_cni.version
  addon_name    = "vpc-cni"

  depends_on = [
    aws_eks_node_group.workers
  ]

}

resource "aws_eks_addon" "coredns" {

  cluster_name  = aws_eks_cluster.srjm-eks.name
  addon_version = data.aws_eks_addon_version.coredns.version
  addon_name    = "coredns"

  depends_on = [
    aws_eks_node_group.workers
  ]

}

resource "aws_eks_addon" "kube_proxy" {

  cluster_name  = aws_eks_cluster.srjm-eks.name
  addon_version = data.aws_eks_addon_version.kube_proxy.version
  addon_name    = "kube-proxy"

  depends_on = [
    aws_eks_node_group.workers
  ]

}

resource "aws_eks_addon" "ebs_csi" {

  cluster_name  = aws_eks_cluster.srjm-eks.name
  addon_version = data.aws_eks_addon_version.ebs_csi.version
  addon_name    = "aws-ebs-csi-driver"

  depends_on = [
    aws_eks_node_group.workers,
    aws_iam_role_policy_attachment.ebs_csi
  ]

}
