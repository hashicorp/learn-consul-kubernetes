# The HCP HVN Resource. Hosts the HCP Vault and Cluster instances
resource "hcp_hvn" "server" {
  cloud_provider = var.cloud_provider
  hvn_id         = var.hvn_name
  region         = var.hcp_region
  cidr_block     = var.cidr_block
}

