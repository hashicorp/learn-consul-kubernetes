variable "eks_cluster_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  description = "Managed Policy for Amazon EKS"
  type = string
}

variable "eks_worker_node_policy_arn" {
  description = "ARN for for the Policy that manages Worker Nodes. Default is AWS managed"
  default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  type = string
}

variable "eks_cni_policy_arn" {
  description = "ARN for the Policy that manages the EKS Custom Network Interface. Default is AWS Managed"
  default = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  type = string
}

variable "ec2_container_registry_read_only_policy_arn" {
  description = "ARN for the Policy that manages Read Only access to the EC2 Container Registry. Default is AWS Managed"
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  type = string
}
