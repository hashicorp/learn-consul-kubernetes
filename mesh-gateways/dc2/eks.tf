# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_name    = "${var.name}"
  cluster_version = "1.21"
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    application = {
      name_prefix      = "${var.name}-ng"
      instance_types   = ["t3a.medium"]
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
    }
  }
  depends_on = [module.vpc]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}