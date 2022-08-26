resource "random_string" "identifier" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

locals {
  identifier        = random_string.identifier.id
  hvn_name          = "${var.hcp_hvn_config.name}-${local.identifier}"
  peer_id           = "${var.hcp_peering_identifier}-${local.identifier}"
  vault_cluster     = "${var.hcp_vault_cluster_name}-${local.identifier}"
  consul_datacenter = "${var.hcp_consul_datacenter_name}-${local.identifier}"
  eks_name          = "${var.cluster_and_vpc_info.name}-${local.identifier}"
  policy_name       = "${var.cluster_and_vpc_info.policy_name}-${local.identifier}"
}

# Builds the base VPC for the AWS EKS Cluster
module "aws_vpc" {
  # Full URL due to this issue: https://github.com/VladRassokhin/intellij-hcl/issues/365
  source             = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version            = "3.11.5"
  name               = local.identifier
  cidr               = var.aws_cidr_block.allocation
  azs                = var.availability_zones
  private_subnets    = var.aws_cidr_block.subnets.private
  public_subnets     = var.aws_cidr_block.subnets.public
  enable_nat_gateway = true
  enable_vpn_gateway = false
  # internal-lb: Permits internal Load Balancer creation when a LoadBalancer type is passed.
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_name}" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
  #elb: Permits Elastic Load Balancer creation when a LoadBalancer type is passed.
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_name}" = "shared"
    "kubernetes.io/role/elb"                  = "1"
  }

}

# Creates required AWS Services to complete the peering relationship. If needed later
# more resources can be added to this module if required for the peering relationship.
module "aws" {
  source     = "./modules/aws"
  aws_vpc_id = module.aws_vpc.vpc_id
  hvn_cidr   = var.hcp_hvn_config.allocation
  aws_cidr   = var.aws_cidr_block.allocation
}

# Sets up an hvn inside hcp
module "hcp_networking_primitives" {
  source         = "./modules/hcp_networking_primitives"
  cloud_provider = var.cloud_provider
  hcp_region     = var.hcp_region
  hvn_name       = local.hvn_name
  cidr_block     = var.hcp_hvn_config.allocation
}

# Creates the peering relationship between HCP and AWS, using the
# defined variables, and module outputs.
module "hcp_networking" {
  source                     = "./modules/hcp_networking"
  aws_region                 = var.region
  aws_account_id             = data.aws_caller_identity.current.id
  aws_vpc_id                 = module.aws_vpc.vpc_id
  aws_default_route_table_id = module.aws_vpc.vpc_main_route_table_id
  aws_vpc_cidr_block         = var.aws_cidr_block.allocation
  hvn_link                   = module.hcp_networking_primitives.hvn_link
  hvn_name                   = module.hcp_networking_primitives.hcp_vpn_id
  hvn_peering_identifier     = local.peer_id
  hcp_hvn_cidr_block         = var.hcp_hvn_config.allocation
  public_route_table_ids     = module.aws_vpc.public_route_table_ids
  private_route_table_ids    = module.aws_vpc.private_route_table_ids
}

# Creates HCP Vault and HCP Consul
module "hcp_applications" {
  source                    = "./modules/hcp_applications"
  hvn_id                    = module.hcp_networking_primitives.hcp_vpn_id
  consul_cluster_datacenter = local.consul_datacenter
  vault_cluster_name        = local.vault_cluster
  hcp_consul_tier           = var.hcp_hvn_config.consul_tier
  hcp_vault_tier            = var.hcp_hvn_config.vault_tier
}

# Deploys Amazon EKS
module "eks" {
  # Full URL due to this issue: https://github.com/VladRassokhin/intellij-hcl/issues/365
  source                          = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version                         = "18.9.0"
  cluster_name                    = local.eks_name
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
    vpc_security_group_ids = [module.aws.aws_security_group_id, module.aws.aws_hashicups_sg]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = var.node_group_configuration.min_instances
      max_size     = var.node_group_configuration.max_instances
      desired_size = var.node_group_configuration.desired_instances
    }
  }
  tags = {
    Environment = var.cluster_and_vpc_info.stage
  }
}

# Update local environment's kubeconfig file.
resource "null_resource" "update_kubeconfig" {

  provisioner "local-exec" {
    command = "aws eks --region ${var.cluster_and_vpc_info.region} update-kubeconfig --name ${module.eks.cluster_id} --alias ${module.eks.cluster_id}"
  }
  depends_on = [module.eks]
}

module "cleanup" {
  source        = "./modules/cleanup"
  vpc_id        = module.aws_vpc.vpc_id
  region        = var.region
  cluster_name  = local.eks_name
  start_cleanup = var.run_cleanup
}

# This module does all the OIDC magic for ServiceAccount -> IAM Role mapping
module "iam_role_for_service_accounts" {
  source    = "registry.terraform.io/terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = local.eks_name
  version   = "4.14.0"

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.kube_namespace}:${var.kube_service_account_name}"]
    }
  }
}

# Creates the policy and policy attachment to the role created above this module. Permits the EKS Cluster
# to describe itself, and assume an IAM Role, which is passed to the Kubernetes Service Account downstream.
module "eks_iam" {
  source      = "./modules/iam"
  cluster_arn = module.eks.cluster_arn
  description = var.cluster_and_vpc_info.policy_description
  policy_name = local.policy_name
  role_name   = module.iam_role_for_service_accounts.iam_role_name
}

# The reader's working environment is its own terraform project, in the ./working-environment folder. To build
# the working environment for the reader, the working environment is treated as an independent terraform state, or
# terraform project. But it is dependent on a kubeconfig file being updated after Amazon EKS is deployed by this project.
# Because a provider takes precedence over resources, this kubeconfig can't be retrieved by the kubernetes provider, as
# the EKS cluster is known after apply, whereas the provider loads the kubeconfig at runtime. The working-environment
# then loads the updated kubeconfig during its run time, and uses this generated tfvars file to bootstrap the required
# values for the reader's environment: a Kubernetes Pod inside the Amazon EKS cluster.
resource "local_file" "kubernetes_tfvars" {
  filename = "./working-environment/terraform.tfvars"
  content  = <<CONFIGURATION
consul_accessor_id="${module.hcp_applications.consul_root_token_accessor_id}"
consul_ca="${module.hcp_applications.consul_ca_file}"
consul_config="${module.hcp_applications.consul_config_file}"
consul_http_addr="${module.hcp_applications.consul_cluster_host}"
consul_http_token="${module.hcp_applications.consul_root_token_secret_id}"
consul_k8s_api_aws="${module.eks.cluster_endpoint}"
consul_secret_id ="${module.hcp_applications.consul_root_token_secret_id}"
vault_addr="${module.hcp_applications.vault_cluster_host}"
vault_namespace="${var.hcp_vault_default_namespace}"
vault_token="${module.hcp_applications.vault_admin_token}"
kube_context="${local.eks_name}"
role_arn="${module.iam_role_for_service_accounts.iam_role_arn}"
profile_name="${var.profile_name}"
cluster_service_account_name="${var.kube_service_account_name}"
cluster_name="${local.eks_name}"
cluster_region="${var.cluster_and_vpc_info.region}"
CONFIGURATION
}
