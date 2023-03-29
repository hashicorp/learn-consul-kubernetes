# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "datacenter_name" {
  default = "dc1"
  description = "Name of the Consul datacenter to create"
}

variable "output_dir" {
  default = "."
  description = "The directory to store output artifacts like kubeconfig files"
}