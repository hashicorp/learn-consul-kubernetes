# The Private Endpoint for HCP Vault
output "vault_cluster_host" {
  value = hcp_vault_cluster.consul_backend.vault_private_endpoint_url
}

# The Vault admin token
output "vault_admin_token" {
  value = hcp_vault_cluster_admin_token.user.token
}

