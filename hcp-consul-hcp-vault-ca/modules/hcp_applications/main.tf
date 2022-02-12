resource "hcp_consul_cluster" "server" {
  cluster_id = var.consul_cluster_datacenter
  hvn_id     = var.hvn_id
  public_endpoint      = var.consul_public_endpoint
  tier = var.hcp_consul_tier
  connect_enabled = true
}

resource "hcp_vault_cluster" "consul_backend" {
  cluster_id = var.vault_cluster_name
  hvn_id     = var.hvn_id
  public_endpoint = var.vault_public_endpoint
  tier = var.hcp_vault_tier
}