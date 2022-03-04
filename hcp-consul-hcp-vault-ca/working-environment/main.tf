module "kubernetes" {
  source = "./modules/kubernetes"

  consul_accessor_id = var.consul_accessor_id
  consul_ca          = var.consul_ca
  consul_config      = var.consul_config
  consul_http_addr   = var.consul_http_addr
  consul_http_token  = var.consul_http_token
  consul_k8s_api_aws = var.consul_k8s_api_aws
  consul_secret_id   = var.consul_secret_id
  vault_addr         = var.vault_addr
  vault_namespace    = var.vault_namespace
  vault_token        = var.vault_token
  kube_context       = var.kube_context
}