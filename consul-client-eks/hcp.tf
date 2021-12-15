resource "hcp_consul_cluster" "example" {
  cluster_id      = var.consul_datacenter_name
  hvn_id          = hcp_hvn.server.hvn_id
  tier            = var.hcp_consul_tier
  public_endpoint = var.consul_public_endpoint
}