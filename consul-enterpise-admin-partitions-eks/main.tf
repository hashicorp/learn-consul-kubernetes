terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    #    TODO: Add this into for explicit required providers
    #    null = {
    #      source = "hashicorp/null"
    #      version = "~> 3.1.0"
    #    }
  }
}
variable "eks_cluster_primary_ips_ufp" {}
variable "eks_cluster_secondary_ips_starfleet" {}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.default_tags
  }
  version = "3.66.0"
}

module "ufp_k8s" {
  source = "./k8s"
  # united_federation_of_planets
  eks_cluster_name             = var.eks_cluster_name
  eks_vpc_cidr_block           = var.eks_cluster_primary_ips_ufp
  eks_vpc_cidr_block_starfleet = var.eks_cluster_secondary_ips_starfleet
  eks_vpc_cidr_block_ufp       = var.eks_cluster_primary_ips_ufp #{
  eks_primary_cluster          = var.eks_cluster_name
}
module "starfleet_k8s" {
  source = "./k8s"
  # terek_nor
  eks_cluster_name             = var.eks_cluster_name_2
  eks_vpc_cidr_block           = var.eks_cluster_secondary_ips_starfleet
  eks_vpc_cidr_block_ufp       = var.eks_cluster_primary_ips_ufp
  eks_vpc_cidr_block_starfleet = var.eks_cluster_secondary_ips_starfleet #{
  eks_primary_cluster          = var.eks_cluster_name
  depends_on                   = [module.ufp_k8s]
}

module "create_peering_starfleet_to_ufp" {
  source           = "./peering"
  vpc_id_accepter  = module.ufp_k8s.vpc_id
  vpc_id_requester = module.starfleet_k8s.vpc_id
}
module "post_route_starfleet_to_ufp" {
  source = "./post_routing"
  # Creates the route for the peering connection from Starfleet's perspective
  vpc_peering_connection_id = module.create_peering_starfleet_to_ufp.vpc_peering_connection_id
  routing_table_id          = module.starfleet_k8s.route_table_id
  vpc_id                    = module.starfleet_k8s.vpc_id
  cidr_block_transit        = var.eks_cluster_primary_ips_ufp.vpc
  main_route_table          = module.starfleet_k8s.main_route_table_id
  private_route_table       = module.starfleet_k8s.route_table_id
}

# Sets up routing for VPC Peering. Runs after VPCs have been created.
module "post_route_ufp_to_starfleet" {
  source                    = "./post_routing"
  vpc_peering_connection_id = module.create_peering_starfleet_to_ufp.vpc_peering_connection_id
  routing_table_id          = module.ufp_k8s.route_table_id
  vpc_id                    = module.ufp_k8s.vpc_id
  cidr_block_transit        = var.eks_cluster_secondary_ips_starfleet.vpc
  main_route_table          = module.ufp_k8s.main_route_table_id
  private_route_table       = module.ufp_k8s.route_table_id
}

module "install_consul_enterprise" {
  source               = "./consul_enterprise"
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_primary  = var.eks_cluster_name
  deploy_type          = "server"
  license_content_path = var.license_file_path
  depends_on           = [module.ufp_k8s]

}
module "install_consul_enterprise_secondary" {
  source               = "./consul_enterprise"
  eks_cluster_name     = var.eks_cluster_name_2
  eks_cluster_primary  = var.eks_cluster_name
  deploy_type          = "client"
  license_content_path = var.license_file_path
  depends_on           = [module.starfleet_k8s]
}
