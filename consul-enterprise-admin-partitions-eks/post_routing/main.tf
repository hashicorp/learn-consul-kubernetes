# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "aws_route" "send_to_main_route_table" {
  route_table_id = var.main_route_table
  destination_cidr_block    = var.cidr_block_transit
  # This represents how we'll get to the above destination cidr block, by using the vpc peering id ('pcx-xxxx')
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

  resource "aws_route" "send_to_private_route_table" {
  route_table_id = var.private_route_table
  destination_cidr_block = var.cidr_block_transit
  vpc_peering_connection_id = var.vpc_peering_connection_id
}