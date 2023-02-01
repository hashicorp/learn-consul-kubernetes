# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# The HVN created in HCP
resource "hcp_hvn" "main" {
  hvn_id         = local.hvn_id
  cloud_provider = "aws"
  region         = var.hvn_region
  cidr_block     = var.hvn_cidr_block
}