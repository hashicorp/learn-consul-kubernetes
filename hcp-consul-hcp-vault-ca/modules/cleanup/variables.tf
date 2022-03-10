variable "vpc_id" {
  type        = string
  description = "VPC ID to cleanup"
}

variable "region" {
  type        = string
  description = "Region to cleanup"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster to cleanup"
}

variable "start_cleanup" {
  type        = bool
  description = "Whether or not start the cleanup process"
}
