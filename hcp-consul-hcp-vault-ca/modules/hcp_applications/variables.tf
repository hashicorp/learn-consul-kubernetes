variable "consul_cluster_datacenter" {
  description = "Name of the Consul datacenter"
  type        = string
}

variable "vault_cluster_name" {
  description = "Vault cluster name"
  type        = string
}

variable "hvn_id" {
  description = "Virtual Network in HCP"
  type        = string
}

variable "consul_public_endpoint" {
  description = "Publicly accessible endpoint for Consul"
  type        = bool
  default     = true
}

variable "vault_public_endpoint" {
  description = "Publicly accessible endpoint for Vault"
  type        = bool
  default     = true
}

variable "hcp_consul_tier" {
  description = "Tier of HCP Consul"
  type        = string
}

variable "hcp_vault_tier" {
  description = "Tier for HCP Vault"
  type        = string
}
