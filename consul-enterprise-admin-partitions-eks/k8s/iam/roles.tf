# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "aws_iam_role" "eks_admin_partition" {
  assume_role_policy = local.assume_policy
  managed_policy_arns = [
    aws_iam_policy.eks_admin_partition.arn,
    var.eks_cluster_policy_arn,
  ]
}
