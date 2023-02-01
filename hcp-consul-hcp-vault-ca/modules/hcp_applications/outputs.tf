# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Endpoint to access HCP Consul
output "consul_cluster_host" {
  value = hcp_consul_cluster.server.consul_private_endpoint_url
}

# The Consul config file to setup the working environment
output "consul_config_file" {
  value = hcp_consul_cluster.server.consul_config_file
}

# The Consul root CA file
output "consul_ca_file" {
  value = hcp_consul_cluster.server.consul_ca_file
}

# The ID for the for Consul root token
output "consul_root_token_accessor_id" {
  value = hcp_consul_cluster_root_token.user.accessor_id
}

# The Consul root token
output "consul_root_token" {
  value = hcp_consul_cluster_root_token.user.kubernetes_secret
}

# The secret ID for the Consul root token
output "consul_root_token_secret_id" {
  value = hcp_consul_cluster_root_token.user.secret_id
}

# The Private Endpoint for HCP Vault
output "vault_cluster_host" {
  value = hcp_vault_cluster.consul_backend.vault_private_endpoint_url
}

# The Vault admin token
output "vault_admin_token" {
  value = hcp_vault_cluster_admin_token.user.token
}

