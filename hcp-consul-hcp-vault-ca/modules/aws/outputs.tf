# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# The id of the AWS VPC Security group for HCP HVN Peering
output "aws_security_group_id" {
  value = aws_security_group.open.id
}

# The id of the Security group for the HashiCups deployment
output "aws_hashicups_sg" {
  value = aws_security_group.hashicups_kubernetes.id
}