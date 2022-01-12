resource "aws_iam_role" "eks_admin_partition" {
  assume_role_policy = local.assume_policy
  managed_policy_arns = [
    aws_iam_policy.eks_admin_partition.arn,
    var.eks_cluster_policy_arn,
  ]
}

#resource "aws_iam_role" "eks_admin_partition" {
#  assume_role_policy = local.user_data2
#  managed_policy_arns = [
#    aws_iam_policy.eks_admin_partition.arn,
#    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  ]
#}