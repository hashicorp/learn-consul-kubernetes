# Creates the resources in Kubernetes for the reader to use their working environment
module "kubernetes" {
  source = "../modules/kubernetes"

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
  role_arn           = var.role_arn
  profile_name       = var.profile_name
  cluster_service_account_name = var.cluster_service_account_name
  cluster_name = var.cluster_name
  cluster_region = var.cluster_region
  consul_datacenter = var.consul_datacenter
}