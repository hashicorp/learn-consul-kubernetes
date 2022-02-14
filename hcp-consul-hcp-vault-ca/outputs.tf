output "eks_cluster_host" {
  value = module.eks.cluster_endpoint
}

output "consul_cert_data" {
  sensitive = true
  value = {
    ca_file = module.hcp_applications.consul_ca_file
    root_accessor_id = module.hcp_applications.consul_root_token_accessor_id
    root_secret_id = module.hcp_applications.consul_root_token_secret_id
    consul_config = module.hcp_applications.consul_config_file
    consul_cluster_host = module.hcp_applications.consul_cluster_host
  }
}