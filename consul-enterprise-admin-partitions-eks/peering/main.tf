# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = var.vpc_id_accepter
  peer_vpc_id = var.vpc_id_requester
  auto_accept = true
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}