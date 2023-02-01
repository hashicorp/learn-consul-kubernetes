# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Authentication data for Consul that is passed to the working environment
output "consul_auth_data" {
  sensitive = true
  value = {
    ca_file             = module.hcp_applications.consul_ca_file
    root_accessor_id    = module.hcp_applications.consul_root_token_accessor_id
    root_secret_id      = module.hcp_applications.consul_root_token_secret_id
    consul_config       = module.hcp_applications.consul_config_file
    consul_cluster_host = module.hcp_applications.consul_cluster_host
    consul_root_token   = module.hcp_applications.consul_root_token
  }
}

# Authentication data for Vault that is passed to the working environment
output "vault_auth_data" {
  sensitive = true
  value = {
    cluster_host = module.hcp_applications.vault_cluster_host
    vault_token  = module.hcp_applications.vault_admin_token
  }
}

# Data for the EKS Cluster that is sent to the working environment
output "eks_data" {
  sensitive = true
  value = {
    eks_host = module.eks.cluster_endpoint
    eks_cert = module.eks.cluster_certificate_authority_data
    eks_arn  = module.eks.cluster_arn
  }
}

# The OIDC Provider ARN. Used to connect AWS IAM Roles to Service Accounts whose identities are managed by the Kubernetes cluster.
# Used to allow the reader to access the AWS CLI in the Pod without copying credentials over.
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

# The Service Account Role ARN created for the EKS Cluster. This is passed to the working environment as a Service
# Annotation in the deployment's podspec.
output "service_account_role_arn" {
  value = module.iam_role_for_service_accounts.iam_role_arn
}