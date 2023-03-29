# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "hvn_name" {
  type        = string
  description = "The name of the HCP HVN"
}

variable "aws_vpc_id" {
  type        = string
  description = "The AWS VPC ID"
}

variable "aws_region" {
  type        = string
  description = "The AWS Region"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID"
}

variable "hvn_peering_identifier" {
  description = "The name of the HCP Peering Connection"
  type        = string
}

variable "aws_vpc_cidr_block" {
  type        = string
  description = "The AWS VPC CIDR Block"
}

variable "hvn_link" {
  description = "A unique URL identifying the HCP Consul cluster."
  type        = string
}

variable "hcp_hvn_cidr_block" {
  type        = string
  description = "The CIDR Block for the HCP HVN"
}

variable "aws_default_route_table_id" {
  type        = string
  description = "The default route table ID for the AWS VPC"
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Route Table IDs for Private Routes"
}

variable "public_route_table_ids" {
  type        = list(string)
  description = "Route Table IDs for Public Routes"
}