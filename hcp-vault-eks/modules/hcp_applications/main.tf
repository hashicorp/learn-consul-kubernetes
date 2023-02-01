# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Creates the HCP Vault Cluster instance
resource "hcp_vault_cluster" "consul_backend" {
  cluster_id      = var.vault_cluster_name
  hvn_id          = var.hvn_id
  public_endpoint = var.vault_public_endpoint
  tier            = var.hcp_vault_tier
}

# Creates the Vault admin token for the working environment
resource "hcp_vault_cluster_admin_token" "user" {
  cluster_id = var.vault_cluster_name
  depends_on = [hcp_vault_cluster.consul_backend]
}