# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# ID of the HCP VPN
output "hcp_vpn_id" {
  value = hcp_hvn.server.hvn_id
}

# URL identifying the HVN
output "hvn_link" {
  value = hcp_hvn.server.self_link
}