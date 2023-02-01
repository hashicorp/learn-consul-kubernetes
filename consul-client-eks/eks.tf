# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_name    = var.datacenter_name
  cluster_version = var.kubernetes_version
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    first = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3

      instance_type = var.ec2_instance_type
    }
  }

  manage_aws_auth    = false
  write_kubeconfig   = true
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
