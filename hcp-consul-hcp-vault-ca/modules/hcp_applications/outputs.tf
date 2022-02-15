output "consul_cluster_host" {
  value = hcp_consul_cluster.server.consul_private_endpoint_url
}

output "consul_config_file" {
  value = hcp_consul_cluster.server.consul_config_file
}

output "consul_ca_file" {
  value = hcp_consul_cluster.server.consul_ca_file
}

output "consul_root_token_accessor_id" {
  value = hcp_consul_cluster_root_token.user.accessor_id
}

output "consul_root_token" {
  value = hcp_consul_cluster_root_token.user.kubernetes_secret
}

output "consul_root_token_secret_id" {
  value = hcp_consul_cluster_root_token.user.secret_id
}

output "vault_cluster_host" {
  value = hcp_vault_cluster.consul_backend.vault_private_endpoint_url
}

output "vault_admin_token" {
  value = hcp_vault_cluster_admin_token.user.token
}

