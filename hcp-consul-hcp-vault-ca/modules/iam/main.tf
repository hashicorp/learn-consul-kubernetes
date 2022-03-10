# Creates the IAM Policy for the EKS Cluster to describe itself and assume IAM Roles
resource "aws_iam_policy" "eks_cluster_describe_and_assume" {
  name = var.policy_name
  policy = templatefile("${path.module}/${var.local_policy_file_path}", {
    cluster_arn = var.cluster_arn
  })
}

# Attached the policy above to a passed role name
resource "aws_iam_role_policy_attachment" "serviceAccountPolicyAttach" {
  policy_arn = aws_iam_policy.eks_cluster_describe_and_assume.arn
  role       = var.role_name
}