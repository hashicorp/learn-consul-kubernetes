data "aws_vpc" "hvn_peer" {
  id = var.vpc_id
}

data "aws_subnet_ids" "hvn_peer" {
  vpc_id = var.vpc_id
}

data "aws_subnet" "hvn_peer" {
  for_each = data.aws_subnet_ids.hvn_peer.ids
  id       = each.value
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  cluster_name    = var.datacenter_name
  cluster_version = "1.17"
  subnets         = [for s in data.aws_subnet.hvn_peer : s.id]

  vpc_id = data.aws_vpc.hvn_peer.id

  node_groups = {
    first = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3

      instance_type = "t2.medium"
    }
  }

  manage_aws_auth    = false
  write_kubeconfig   = true
  config_output_path = pathexpand("${var.output_dir}/${var.datacenter_name}")
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  load_config_file       = false
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
