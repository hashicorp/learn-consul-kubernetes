# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "versions" {
  type        = any
  description = "Versions of software used in the startup script"
  default = {
    kubectl_version    = "v1.22.4"
    helm_version       = "v3.7.1"
    consul_version     = "1.11.4+ent"
    consul_k8s_version = "0.40.0"
    amazonlinux        = "amazonlinux:2"
    yq_version         = "v4.20.2"
  }
}

variable "consul_ca" {
  type        = string
  description = "Consul CA File"
}

variable "consul_http_token" {
  description = "Consul HTTP Token for CLI/API access"
  type        = string
}

variable "consul_config" {
  type        = string
  description = "Consul Config file, base64 encoded"
}

variable "consul_http_addr" {
  description = "HCP Consul Cluster endpoint"
  type        = string
}

variable "consul_k8s_api_aws" {
  description = "Kubernetes cluster endpoint URL"
  type        = string
}

variable "consul_accessor_id" {
  description = "Accessor ID for token"
  type        = string
}

variable "consul_secret_id" {
  description = "Secret ID for token"
  type        = string
}

variable "vault_token" {
  description = "Vault token"
  type        = string
}

variable "vault_addr" {
  description = "Vault endpoint"
  type        = string
}

variable "vault_namespace" {
  type        = string
  description = "Default Namespace in HCP Vault"
}

variable "pod_replicas" {
  description = "Number of pod replicas for the working environment"
  default     = "1"
}

variable "tutorial_name" {
  description = "Name of tutorial working environment"
  default     = "tutorial"
}

variable "startup_script_options" {
  type        = any
  description = "Configuration settings for the kube configmap for the startup script"
  default = {
    file_permissions     = "0744"
    config_map_name      = "tutorial-startup-scripts"
    config_map_file_name = "startup.sh"
    mount_path           = "/startup"
    startup_command      = "/startup/startup.sh"
    volume_name          = "startup"
    template_file_name   = "template_scripts/startup-script.tftpl"
  }
}

variable "aws_creds_options" {
  type        = any
  description = "Creates the AWS credentials file which is directed towards the IAM Role associated with the Pod. Does not use password or token based authentication"
  default = {
    config_map_name     = "aws-credentials"
    config_map_filename = "credentials"
    mount_path          = "/root/.aws/credentials"
    volume_name         = "aws-credentials"
    template_file_name  = "template_scripts/aws-credentials.tftpl"
    file_permissions    = "0755"
  }
}

variable "aws_profile_config_options" {
  type        = any
  description = "Creates the configmap settings for the config that includes a profile for the aws credentials file"
  default = {
    config_map_name     = "aws-profile"
    config_map_filename = "config"
    mount_path          = "/root/.aws/config"
    volume_name         = "aws-profile"
    template_file_name  = "template_scripts/aws-profile-config.tftpl"
    file_permissions    = "0755"
  }
}

variable "profile_name" {
  type        = string
  description = "Name of the AWS Profile"
}

variable "role_arn" {
  type        = string
  description = "ARN of the IAM Role that is mapped to a Kubernetes service account"
}

variable "cluster_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account mapped to the IAM Role."
}

variable "cluster_region" {
  type        = string
  description = "Region for the EKS cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name for the EKS Cluster."
}

variable "kube_context" {
  type        = string
  description = "The name of the kube context to set in the config file for kubectl"
}

