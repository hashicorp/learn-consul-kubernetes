# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "vault_cluster_name" {
  description = "Vault cluster name"
  type        = string
}

variable "hvn_id" {
  description = "Virtual Network in HCP"
  type        = string
}

variable "vault_public_endpoint" {
  description = "Publicly accessible endpoint for Vault"
  type        = bool
  default     = true
}

variable "hcp_vault_tier" {
  description = "Tier for HCP Vault"
  type        = string
}
