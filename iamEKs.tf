# resource "aws_iam_user" "developer" {
#   name = "jm-dev"
# }

# resource "aws_eks_access_entry" "developer" {
#   cluster_name      = aws_eks_cluster.srjm-eks.name
#   principal_arn     = aws_iam_user.developer.arn
#   kubernetes_groups = ["developers"]
# }