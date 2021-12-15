locals {
  user_data2 = file("${path.module}/config/assume_role_policy.json")
}

resource "aws_iam_role" "eks_admin_partition" {
  #assume_role_policy = aws_iam_policy.eks_admin_partition.policy
  assume_role_policy = local.user_data2
  managed_policy_arns = [
    aws_iam_policy.eks_admin_partition.arn,
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

resource "aws_iam_policy_attachment" "EKSWorkerNodePolicy" {
  name       = "Test1"
  roles = [
    aws_iam_role.eks_admin_partition.name
  ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "EKSCNIPolicy" {
  name = "Test2"
  roles = [
    aws_iam_role.eks_admin_partition.name
  ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "EC2ContainerRegistryReadOnly" {
  name       = "Test3"
  roles = [
    aws_iam_role.eks_admin_partition.name
  ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "EKSClusterPolicy" {
  name       = "Test4"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles = [
    aws_iam_role.eks_admin_partition.name
  ]
}

output "eks_admin_partition_arn" {
  value = aws_iam_role.eks_admin_partition.arn
}