variable "vpc_id" {
  description = "VPC ID of VPC you have peered with your HCP HVN"
}

variable "region" {
  default = "us-west-2"
  description = "The region"
}

variable "datacenter_name" {
  default = "hcp-dc1"
  description = "Name of the Consul datacenter to create"
}

variable "output_dir" {
  default = "."
  description = "The directory to store output artifacts like kubeconfig files"
}