module "iam" {
  source = "./iam"
}
module "networking" {
  source = "./networking"
  lib_cluster_name = var.eks_cluster_name
  eks_cidr_blocks = var.eks_vpc_cidr_block
  availability_zones = var.availability_zones
}

resource "aws_eks_cluster" "primary" {
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
  cidr_blocks = [var.eks_vpc_cidr_block_primary.public, var.eks_vpc_cidr_block_primary.private, var.eks_vpc_cidr_block_secondary.private, var.eks_vpc_cidr_block_secondary.public]
  depends_on = [aws_eks_cluster.primary]
}

resource "aws_eks_node_group" "public" {
  node_group_name_prefix = "ngPublic"
  cluster_name  = aws_eks_cluster.primary.name
  node_role_arn = module.iam.eks_admin_partition_arn
  subnet_ids    = [module.networking.subnet_ids.public]

  scaling_config {
    desired_size = var.number_of_nodes.public.desired
    max_size     = var.number_of_nodes.public.max_nodes
    min_size     = var.number_of_nodes.public.min_nodes
  }
  labels = {
    "type" = "public"
  }
  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "Name" = "eks_node_group_public_instances"
  }

  instance_types = ["m5.large"]
  disk_size = 100
}

resource "aws_eks_node_group" "private" {
  node_group_name_prefix = "ngPriv"
  cluster_name  = aws_eks_cluster.primary.name
  node_role_arn = module.iam.eks_admin_partition_arn
  subnet_ids    = [module.networking.subnet_ids.private]

  scaling_config {
    desired_size = var.number_of_nodes.private.desired
    max_size     = var.number_of_nodes.private.max_nodes
    min_size     = var.number_of_nodes.private.min_nodes
  }
  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "Name" = "eks_node_group_private_instances"
  }
  labels = {
    "type" = "private"
  }
  instance_types = ["m5.large"]
  disk_size = 100
}



