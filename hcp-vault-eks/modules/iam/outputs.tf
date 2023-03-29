# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "policy_arn" {
  value = aws_iam_policy.eks_cluster_describe_and_assume.arn
}
