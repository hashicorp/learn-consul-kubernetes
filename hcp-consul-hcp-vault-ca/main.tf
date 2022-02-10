# Builds the base VPC for the AWS EKS Cluster
module "aws_vpc" {
  # Full URL due to this issue: https://github.com/VladRassokhin/intellij-hcl/issues/365
  source             = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version            = "3.11.5"
  name               = "test"
  cidr               = var.aws_cidr_block.allocation
  azs                = var.availability_zones
  private_subnets    = var.aws_cidr_block.subnets.private
  public_subnets     = var.aws_cidr_block.subnets.public
  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Sets up the Security Group for EKS
module "aws" {
  # TODO Make this name more explicitly defined as to its purpose
  source                     = "./modules/aws"
  aws_vpc_id                 = module.aws_vpc.vpc_id
}

# Sets up an hvn inside hcp
module "hcp_networking_primitives" {
  source                 = "./modules/hcp_networking_primitives"
  cloud_provider         = var.cloud_provider
  hcp_region             = var.hcp_region
  hvn_name               = var.hcp_hvn_config.name

}

# Creates the peering relationship between HCP and AWS, using the
# defined variables, and module outputs.
module "hcp_networking" {
  source                     = "./modules/hcp_networking"
  aws_region                 = var.region
  aws_account_id             = data.aws_caller_identity.current.id
  aws_vpc_id                 = module.aws_vpc.vpc_id
  vpc_default_route_table_id = module.aws_vpc.default_route_table_id
  aws_vpc_cidr_block         = var.aws_cidr_block.allocation
  hvn_link                   = module.hcp_networking_primitives.hvn_link
  hvn_name                   = module.hcp_networking_primitives.hcp_vpn_id
  hvn_peering_identifier     = var.hcp_peering_identifier
  hcp_hvn_cidr_block         = var.hcp_hvn_config.allocation
}

module "hcp_applications" {
  source = "./modules/hcp_applications"
  hvn_id = module.hcp_networking_primitives.hcp_vpn_id
  consul_cluster_datacenter = var.hcp_consul_datacenter_name
  vault_cluster_name = var.hcp_vault_cluster_name
}

module "eks" {
  # Full URL due to this issue: https://github.com/VladRassokhin/intellij-hcl/issues/365
  source                          = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version                         = "18.3.0"
  cluster_name                    = "tutorialCluster"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id = module.aws_vpc.vpc_id
  subnet_ids = setunion(
  module.aws_vpc.public_subnets,
  module.aws_vpc.private_subnets
  )

  # Node Groups
  eks_managed_node_group_defaults = {
    ami_type               = var.node_group_configuration.ami_type
    disk_size              = var.node_group_configuration.disk_size_gigs
    instance_types         = var.node_group_configuration.instance_types
    vpc_security_group_ids = [module.aws.aws_security_group_id]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 2
      max_size     = 2
      desired_size = 2
    }
  }
  tags = {
    Environment = "dev"
  }
}




