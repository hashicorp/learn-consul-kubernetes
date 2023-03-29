# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "number_of_nodes" {
  description = "Number of EKS EC2 nodes to launch within a node group"
  type = map(map(number))
  default = {
    public = {
      desired = 2
      max_nodes = 2
      min_nodes = 2
    }
    private = {
      desired = 2
      max_nodes = 2
      min_nodes = 2
    }
  }
}
variable "eks_vpc_cidr_block_primary" {}
variable "eks_vpc_cidr_block_secondary" {}
variable "eks_vpc_cidr_block" {}
variable "eks_cluster_name" {}
variable "eks_primary_cluster" {}
variable "availability_zones" {}


