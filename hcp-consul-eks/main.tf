# Create unique resources

locals {
  unique_id = random_id.unique_identifier.b64_url
  vpc_name = "${var.cluster_and_vpc_info.vpc_name}-${local.unique_id}"
  hvn_name = "${var.hcp_hvn_config.name}-${local.unique_id}"
  hcp_peering_id = "${var.hcp_peering_identifier}-${local.unique_id}"
  consul_datacenter_name = "${var.hcp_consul_datacenter_name}-${local.unique_id}"
  vault_cluster_name = "${var.hcp_vault_cluster_name}-${local.unique_id}"
  eks_cluster_name = "${var.cluster_and_vpc_info.name}-${local.unique_id}"
  policy_name = "${var.cluster_and_vpc_info.policy_name}-${local.unique_id}"

}

resource "random_id" "unique_identifier" {
  byte_length = 2
}

# Builds the base VPC for the AWS EKS Cluster
module "aws_vpc" {
    # Keep full URL for tf registry modules for cross-IDE compatibility.
    source              = "registry.terraform.io/terraform-aws-modules/vpc/aws"
    version             = "3.11.5"
    name                = local.vpc_name#var.cluster_and_vpc_info.vpc_name
    cidr                = var.aws_cidr_block.allocation
    azs                 = var.availability_zones
    private_subnets     = var.aws_cidr_block.subnets.private
    public_subnets      = var.aws_cidr_block.subnets.public
    enable_nat_gateway  = true
    enable_vpn_gateway  = false
    # internal-lb: Permits internal Load Balancer creation when a LoadBalancer type is passed.
    private_subnet_tags = {
      "kubernetes.io/cluster/${var.cluster_and_vpc_info.name}" = "shared"
      "kubernetes.io/role/internal-elb"                        = "1"
    }
    #elb: Permits Elastic Load Balancer creation when a LoadBalancer type is passed.
    public_subnet_tags = {
      "kubernetes.io/cluster/${var.cluster_and_vpc_info.name}" = "shared"
      "kubernetes.io/role/elb"                                 = "1"
    }

    tags = {
      Terraform   = "true"
      Environment = var.cluster_and_vpc_info.stage
    }
  }


# Deploys Amazon EKS
module "eks" {
  source                          = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version                         = "18.9.0"
  cluster_name                    = local.eks_cluster_name
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

  eks_managed_node_group_defaults = {
    ami_type               = var.node_group_configuration.ami_type
    disk_size              = var.node_group_configuration.disk_size_gigs
    instance_types         = var.node_group_configuration.instance_types
    vpc_security_group_ids = [module.hcp.aws_security_group_id]
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

# Creates the policy and policy attachment to the role created above this module. Permits the EKS Cluster
# to describe itself, and assume an IAM Role, which is passed to the Kubernetes Service Account downstream.
module "eks_iam" {
  source      = "github.com/webdog/terraform-eks-iam-cluster-describe"
  cluster_arn = module.eks.cluster_arn
  description = var.cluster_and_vpc_info.policy_description
  policy_name = local.policy_name
  role_name   = module.iam_role_for_service_accounts.iam_role_name
}

# This module maps Kubernetes ServiceAccount -> IAM Role
module "iam_role_for_service_accounts" {
  source    = "registry.terraform.io/terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = lower(local.eks_cluster_name)
  version   = "4.14.0"

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.kube_namespace}:${var.kube_service_account_name}"]
    }
  }
}


# Cleanup ENI module
# This module's resources only run when `terraform destroy` is invoked by the user. A "start_cleanup" variable
# is used to make sure cleanup scripts are not run during a follow up terraform apply, and only during terraform destroy.
# This is passed as TF_VAR_start_cleanup=true to the main project by the reader at the end of the tutorial:
# export TF_VAR_run_cleanup=true; terraform destroy -auto-approve
module "eni_cleanup" {
  source = "github.com/webdog/terraform-kubernetes-delete-eni"
  vpc_id= module.aws_vpc.vpc_id
  region = var.region
}


# Creates the peering relationship between HCP and AWS, using the
# defined variables, and module outputs.
module "hcp" {
  source                     = "github.com/webdog/terraform-hcp-consul-cluster"
  aws_region                 = var.region
  aws_account_id             = data.aws_caller_identity.current.id
  aws_vpc_id                 = module.aws_vpc.vpc_id
  aws_default_route_table_id = module.aws_vpc.vpc_main_route_table_id
  aws_vpc_cidr_block         = var.aws_cidr_block.allocation
  hvn_peering_identifier     = local.hcp_peering_id
  hcp_hvn_cidr_block         = var.hcp_hvn_config.allocation
  public_route_table_ids     = module.aws_vpc.public_route_table_ids
  private_route_table_ids    = module.aws_vpc.private_route_table_ids
  cloud_provider             = var.cloud_provider
  hcp_region                 = var.hcp_region
  hvn_name                   = local.hvn_name
  cidr_block                 = var.hcp_hvn_config.allocation
  consul_cluster_datacenter  = local.consul_datacenter_name
  hcp_consul_tier            = var.hcp_hvn_config.consul_tier
  aws_cidr                   = var.aws_cidr_block.allocation
  hvn_cidr                   = var.hcp_hvn_config.allocation
  hvn_id                     = local.hvn_name
}


# Safely update local environment's kubeconfig file.
resource "null_resource" "update_kubeconfig" {

  provisioner "local-exec" {
    # Create empty kubeconfig if it doesn't exist. If it does exist, touch does nothing, but back up the config in either case and use a kubeconfig that is unique for this tutorial. Is deleted during terraform destroy
    command = "mv ~/.kube/config ~/.kube/config.bkp && aws eks --region ${var.cluster_and_vpc_info.region} update-kubeconfig --name ${module.eks.cluster_id} --alias ${var.cluster_and_vpc_info.name}"
  }
  depends_on = [module.eks]
}