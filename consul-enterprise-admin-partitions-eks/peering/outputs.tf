# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.peering.id
}