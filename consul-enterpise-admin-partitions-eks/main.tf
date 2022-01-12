terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
    #    TODO: Add this into for explicit required providers
    #    null = {
    #      source = "hashicorp/null"
    #      version = "~> 4.1.0"
    #    }
  }
}
variable "eks_cluster_primary_ips_starfleet" {}
variable "eks_cluster_secondary_ips_terek_nor" {}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.default_tags
  }
  #version = "3.66.0"
}

module "starfleet_k8s" {
  source = "./k8s"
  # starfleet
  eks_cluster_name             = var.eks_cluster_name_1
  eks_vpc_cidr_block           = var.eks_cluster_primary_ips_starfleet
  eks_vpc_cidr_block_starfleet = var.eks_cluster_primary_ips_starfleet
  eks_vpc_cidr_block_terek_nor = var.eks_cluster_secondary_ips_terek_nor
  eks_primary_cluster          = var.eks_cluster_name_1
}
module "terek_nor_k8s" {
  source = "./k8s"
  # terek_nor
  eks_cluster_name             = var.eks_cluster_name_2
  eks_vpc_cidr_block           = var.eks_cluster_secondary_ips_terek_nor
  eks_vpc_cidr_block_starfleet = var.eks_cluster_primary_ips_starfleet
  eks_vpc_cidr_block_terek_nor = var.eks_cluster_secondary_ips_terek_nor
  eks_primary_cluster          = var.eks_cluster_name_1
  depends_on                   = [module.starfleet_k8s]
}

module "create_peering_terek_nor_to_starfleet" {
  source           = "./peering"
  vpc_id_accepter  = module.starfleet_k8s.vpc_id
  vpc_id_requester = module.terek_nor_k8s.vpc_id
}
module "post_route_terek_nor_to_starfleet" {
  source = "./post_routing"
  # Creates the route for the peering connection from terek_nor's perspective
  vpc_peering_connection_id = module.create_peering_terek_nor_to_starfleet.vpc_peering_connection_id
  routing_table_id          = module.terek_nor_k8s.route_table_id
  vpc_id                    = module.terek_nor_k8s.vpc_id
  cidr_block_transit        = var.eks_cluster_primary_ips_starfleet.vpc
  main_route_table          = module.terek_nor_k8s.main_route_table_id
  private_route_table       = module.terek_nor_k8s.route_table_id
}

# Sets up routing for VPC Peering. Runs after VPCs have been created.
module "post_route_starfleet_to_terek_nor" {
  source                    = "./post_routing"
  vpc_peering_connection_id = module.create_peering_terek_nor_to_starfleet.vpc_peering_connection_id
  routing_table_id          = module.starfleet_k8s.route_table_id
  vpc_id                    = module.starfleet_k8s.vpc_id
  cidr_block_transit        = var.eks_cluster_secondary_ips_terek_nor.vpc
  main_route_table          = module.starfleet_k8s.main_route_table_id
  private_route_table       = module.starfleet_k8s.route_table_id
}

module "install_consul_enterprise" {
  source              = "./consul_enterprise"
  eks_cluster_name    = var.eks_cluster_name_1
  eks_cluster_primary = var.eks_cluster_name_1
  deploy_type         = "server"
  license_name        = var.license_name
  cluster_subnet_id   = module.starfleet_k8s.public-subnet-id
  vpc_id              = module.starfleet_k8s.vpc_id
  depends_on          = [module.starfleet_k8s]

}
module "install_consul_enterprise_secondary" {
  source              = "./consul_enterprise"
  eks_cluster_name    = var.eks_cluster_name_2
  eks_cluster_primary = var.eks_cluster_name_1
  deploy_type         = "client"
  license_name        = var.license_name
  cluster_subnet_id   = module.terek_nor_k8s.public-subnet-id
  vpc_id              = module.terek_nor_k8s.vpc_id
  depends_on          = [module.terek_nor_k8s, module.install_consul_enterprise]
}
