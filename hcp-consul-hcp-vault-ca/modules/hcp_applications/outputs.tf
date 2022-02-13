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
  value = hcp_consul_cluster.server.consul_root_token_accessor_id
}

output "consul_root_token_secret_id" {
  value = hcp_consul_cluster.server.consul_root_token_secret_id
}

