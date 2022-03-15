# Creates the HCP Consul Server instance
resource "hcp_consul_cluster" "server" {
  cluster_id      = var.consul_cluster_datacenter
  hvn_id          = var.hvn_id
  public_endpoint = var.consul_public_endpoint
  tier            = var.hcp_consul_tier
  connect_enabled = true
}

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

# Creates the root Consul token for the working environment
resource "hcp_consul_cluster_root_token" "user" {
  depends_on = [hcp_consul_cluster.server]
  cluster_id = var.consul_cluster_datacenter
}