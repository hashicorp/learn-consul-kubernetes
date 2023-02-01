# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "consul_addr" {
  value = hcp_consul_cluster.main.consul_public_endpoint_url
}

output "consul_datacenter" {
  value = hcp_consul_cluster.main.datacenter
}

output "consul_token" {
  value     = hcp_consul_cluster_root_token.token.secret_id
  sensitive = true
}

output "kubernetes_cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "region" {
  value = var.vpc_region
}

output "kubernetes_cluster_id" {
  value = module.eks.cluster_id
}

output "vpc" {
  value = {
    vpc_id         = module.vpc.vpc_id
    vpc_cidr_block = module.vpc.vpc_cidr_block
    hvn_cidr_block = var.hvn_cidr_block
  }
}