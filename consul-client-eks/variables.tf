# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  default = "us-east-1"
  description = "The region"
}

variable "datacenter_name" {
  default = "dc1"
  description = "Name of the Consul datacenter to create"
}

variable "output_dir" {
  default = "."
  description = "The directory to store output artifacts like kubeconfig files"
}

variable "kubernetes_version" {
  type = string
  description = "The version of Kubernetes to use"
  default = "1.21"
}

variable "ec2_instance_type" {
  type = string
  description = "The underlying EC2 instance type to use"
  default = "t2.medium"
}

variable "default_tags" {
  description = "Default Tags for AWS"
  type        = map(string)
  default = {
    Environment       = "dev"
    Team              = "Education-Consul"
    terraform_managed = true
    deletePrevention  = false
  }
}