variable "aws_region" {
  type = string
  description = "VPC region"
}

variable "vpc_id" {
  type        = string
  description = "AWS VPC ID"
}

variable "vpc_cidr_block" {
  type        = string
  description = "AWS CIDR block"
}

variable "subnet_id" {
  type        = string
  description = "AWS subnet (public)"
}

variable "cluster_id" {
  type        = string
  description = "Consul cluster ID"
}

variable "vpc_security_group_id" {
  type        = string
  description = "AWS Security group for HCP Consul"
}

variable "cts_version" {
  type        = string
  description = "CTS version to install"
  default     = "0.6.0+ent"
}

variable "consul_version" {
  type        = string
  description = "Consul version to install"
  default     = "v1.12.0"
}

variable "consul_root_token" {
  type = string
  description = "Consul client agent token"
  default = ""
}
