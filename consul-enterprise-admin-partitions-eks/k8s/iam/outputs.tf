# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "eks_admin_partition_arn" {
  value = aws_iam_role.eks_admin_partition.arn
}