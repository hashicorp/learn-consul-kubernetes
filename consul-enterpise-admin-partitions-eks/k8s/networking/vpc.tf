variable "lib_cluster_name" {}
variable "eks_cidr_blocks" {}


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
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    "kubernetes.io/cluster/${var.lib_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
    Name = "${var.lib_cluster_name}_us_east_1a"
  }
}
resource "aws_subnet" "public" {
  cidr_block = var.eks_cidr_blocks.public
  vpc_id     = aws_vpc.admin_partition_vpc.id
  availability_zone = "us-east-1f"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.lib_cluster_name}" = "shared"
    Name = "${var.lib_cluster_name}_us_east_1f"
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
resource "aws_internet_gateway" "ap-igw" {
  vpc_id = aws_vpc.admin_partition_vpc.id
  tags = {
    Name = "${var.lib_cluster_name}_igw"
  }
}
# These two resources create the public subnet route table, and make this route table the main rt for the VPC
resource "aws_route_table" "admin_partitions_rt" {
  vpc_id = aws_vpc.admin_partition_vpc.id
  tags = {
    Name = "${var.lib_cluster_name}-manually_declared"
  }
  route {
    cidr_block = var.eks_cidr_blocks.internet
    gateway_id = aws_internet_gateway.ap-igw.id
  }
}
# Route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.admin_partition_vpc.id
  tags   = {
    Name = "${var.lib_cluster_name}-manually_declared"
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
# Associates the public route table created to to be the main route table of the VPC
resource "aws_main_route_table_association" "admin_partitions" {
  route_table_id = aws_route_table.admin_partitions_rt.id
  vpc_id         = aws_vpc.admin_partition_vpc.id
}
# These resources associate the subnet resources with the route table above.
resource "aws_route_table_association" "admin_partitions_rt_assoc1" {
  route_table_id = aws_route_table.admin_partitions_rt.id
  subnet_id = aws_subnet.public.id
}


output "subnet_ids" {
  #type = map(string)
  value = {
    private = aws_subnet.private.id
    public = aws_subnet.public.id
    }
}
output "vpc_id" {
  value = aws_vpc.admin_partition_vpc.id
}
output "route_table_id" {
  # Output to associate the peering connection. Each VPC will peer via the private subnet of the VPC
  value = aws_route_table.private.id
}
output "main_route_table_id" {
  value = aws_route_table.admin_partitions_rt.id
}

