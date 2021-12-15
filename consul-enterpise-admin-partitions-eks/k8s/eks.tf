variable "eks_cluster_name" {}
variable "eks_primary_cluster" {}
variable "eks_vpc_cidr_block_ufp" {}
variable "eks_vpc_cidr_block_starfleet" {}
variable "eks_vpc_cidr_block" {}

module "iam" {
  source = "./iam"
}
module "networking" {
  source = "./networking"
  lib_cluster_name = var.eks_cluster_name
  eks_cidr_blocks = var.eks_vpc_cidr_block
}

resource "aws_eks_cluster" "primary" {
  # The EKS cluster name is defined in the root variables.tf
  # This value is passed along to the networking module above.
  name     = var.eks_cluster_name
  role_arn = module.iam.eks_admin_partition_arn
  vpc_config {
    subnet_ids = [module.networking.subnet_ids.private,
                  module.networking.subnet_ids.public]
    endpoint_public_access = true
    endpoint_private_access = true
  }
}
module "update_eks_cluster_sgs" {
  source = "./create-new-sg"
  vpc_id = module.networking.vpc_id
  existing_sg_id = aws_eks_cluster.primary.vpc_config.0.cluster_security_group_id
  cidr_blocks = [var.eks_vpc_cidr_block_ufp.public, var.eks_vpc_cidr_block_ufp.private, var.eks_vpc_cidr_block_starfleet.private, var.eks_vpc_cidr_block_starfleet.public]
  depends_on = [aws_eks_cluster.primary]
}

data "aws_security_group" "eks_cluster" {
  id = aws_eks_cluster.primary.vpc_config.0.cluster_security_group_id
}

resource "aws_eks_node_group" "public" {
  node_group_name_prefix = "wdpub"
  cluster_name  = aws_eks_cluster.primary.name
  node_role_arn = module.iam.eks_admin_partition_arn
  subnet_ids    = [module.networking.subnet_ids.public]

  scaling_config {
    desired_size = var.number_of_nodes.voyager.desired
    max_size     = var.number_of_nodes.voyager.max_nodes
    min_size     = var.number_of_nodes.voyager.min_nodes
  }
  labels = {
    "type" = "public"
  }
  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "Name" = "webdog-eks_cluster_node_public_instances"
  }

  instance_types = ["m5.large"]
  disk_size = 100
}
resource "aws_eks_node_group" "private" {
  node_group_name_prefix = "wdpriv"
  cluster_name  = aws_eks_cluster.primary.name
  node_role_arn = module.iam.eks_admin_partition_arn
  subnet_ids    = [module.networking.subnet_ids.private]

  scaling_config {
    desired_size = var.number_of_nodes.voyager.desired
    max_size     = var.number_of_nodes.voyager.max_nodes
    min_size     = var.number_of_nodes.voyager.min_nodes
  }
  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "Name" = "webdog-eks_cluster_node_public_instances"
  }
  labels = {
    "type" = "private"
  }
  instance_types = ["m5.large"]
  disk_size = 100
}

output "vpc_id" {
  value = module.networking.vpc_id
}
output "route_table_id" {
  value = module.networking.route_table_id
}
output "main_route_table_id" {
  value = module.networking.main_route_table_id
}
output "security_group_id" {
  value = aws_eks_cluster.primary.vpc_config.0.cluster_security_group_id
}


