# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "aws_vpc" "admin_partition_vpc" {
  cidr_block = var.eks_cidr_blocks.vpc
  tags = {
    Name = var.lib_cluster_name
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}
#
resource "aws_subnet" "private" {
  cidr_block = var.eks_cidr_blocks.private
  vpc_id     = aws_vpc.admin_partition_vpc.id
  availability_zone = var.availability_zones.zone_one
  map_public_ip_on_launch = false
  tags = {
    "kubernetes.io/cluster/${var.lib_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
     Name = "${var.lib_cluster_name}_${var.availability_zones.zone_one}"

  }
}
resource "aws_subnet" "public" {
  cidr_block = var.eks_cidr_blocks.public
  vpc_id     = aws_vpc.admin_partition_vpc.id
  availability_zone = var.availability_zones.zone_two
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.lib_cluster_name}" = "shared"
     Name = "${var.lib_cluster_name}_${var.availability_zones.zone_two}"
  }
}
# eip for nat gateway
resource "aws_eip" "nat_gw" {
  vpc = true
}

# NAT gateway to let the private subnet to connect to the internet.
resource "aws_nat_gateway" "private" {
  subnet_id = aws_subnet.public.id
  allocation_id = aws_eip.nat_gw.id

}
# The public subnet uses this to connect to the internet
resource "aws_internet_gateway" "admin_partitions" {
  vpc_id = aws_vpc.admin_partition_vpc.id
  tags = {
    Name = "${var.lib_cluster_name}"
  }
}

# The following two resources create the public subnet route table, and make this route table the main rt for the VPC
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.admin_partition_vpc.id
  tags = {
    Name = "${var.lib_cluster_name}-created_in_terraform"
  }
  route {
    cidr_block = var.eks_cidr_blocks.internet
    gateway_id = aws_internet_gateway.admin_partitions.id
  }
}
# Route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.admin_partition_vpc.id
  tags   = {
    Name = "${var.lib_cluster_name}-created_in_terraform"
  }
  # Sometimes the route table creation or deletion can take longer than the default timeout. Increasing for
  # wiggle room.
  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
  route {
    # Create a route to the internet via the NAT gateway.
    cidr_block     = var.eks_cidr_blocks.internet
    nat_gateway_id = aws_nat_gateway.private.id
  }
}
# Associate aws_route_table.private to the private subnet.
resource "aws_route_table_association" "private_rt_association" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private.id
}
# Associates the previously named "main" route table created as the main route table of the VPC
resource "aws_main_route_table_association" "convert_manually_created" {
  route_table_id = aws_route_table.main.id
  vpc_id         = aws_vpc.admin_partition_vpc.id
}
# This resource associate the subnet resources with the new main route table.
resource "aws_route_table_association" "add_public_subnet_to_main_route_table" {
  route_table_id = aws_route_table.main.id
  subnet_id = aws_subnet.public.id
}