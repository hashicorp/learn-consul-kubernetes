# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "consul_ca" {
  type = string
  description = "Consul CA file"
}

variable "consul_http_token" {
  type = string
  description = "Consul HTTP Token"
}

variable "consul_config" {
  type = string
  description = "base64 encoded consul config file"
}

variable "consul_http_addr" {
  type = string
  description = "Consul endpoint"
}

variable "consul_k8s_api_aws" {
  type = string
  description = "Kubernetes endpoint"
}

variable "consul_accessor_id" {
  type = string
  description = "Consul Accessor ID"
}

variable "consul_secret_id" {
  type = string
  description = "Consul secret ID"
}

variable "vault_token" {
  type = string
  description = "Vault token"
}

variable "vault_addr" {
  type = string
  description = "Vault private endpoint URL"
}

variable "vault_namespace" {
  type = string
  description = "Vault namespace"
}

variable "pod_replicas" {
  type = string
  default = "1"
}

variable "tutorial_name" {
  type = string
  description = "Name of tutorial working environment"
  default = "tutorial"
}

variable "kube_context" {
  type = string
  description = "Kube context"
}
#
variable "profile_name" {
  type = string
  description = "Profile name for AWS credentials"
}

variable "role_arn" {
  type = string
  description = "ARN for IAM Role"
}

variable "cluster_name" {
  type = string
  description = "Name of EKS Cluster"
}

variable "cluster_region" {
  type = string
  description = "Region of EKS Cluster"
}

variable "cluster_service_account_name" {
  type = string
  description = "Service account name for the Pod"
}