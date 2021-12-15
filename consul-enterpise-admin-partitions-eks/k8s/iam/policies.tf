locals {
  user_data = file("${path.module}/config/policy.json")
}


resource "aws_iam_policy" "eks_admin_partition" {
  policy = local.user_data
}