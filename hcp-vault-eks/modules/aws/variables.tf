# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_vpc_id" {
  type        = string
  description = "VPC ID passed in to this module"
}

variable "hvn_cidr" {
  type        = string
  description = "CIDR Block for HCP"
}

variable "aws_cidr" {
  type        = string
  description = "CIDR Block for AWS"
}