variable "routing_table_id" {}
variable "vpc_peering_connection_id" {}
variable "vpc_id" {}
variable "cidr_block_transit" {}
variable "main_route_table" {}
variable "private_route_table" {}


# Send all 10.100.0.0/16 to the pcx on the main route table
resource "aws_route" "send_to_vpc_peering" {
  route_table_id = var.main_route_table
  # This cidr block represents the destination we will go to in this specific route.
  # I.e. This subnet will go to this CIDR block via this route.
  destination_cidr_block    = var.cidr_block_transit
  # This represents how we'll get to the above destination cidr block, by using the vpc peering id ('pcx-xxxx')
  vpc_peering_connection_id = var.vpc_peering_connection_id
}
# Send 10.100 traffic to the pcx in the private route table for the private subnet
resource "aws_route" "starfleet-to-ufp_main_route" {
  route_table_id = var.private_route_table
  destination_cidr_block = var.cidr_block_transit
  vpc_peering_connection_id = var.vpc_peering_connection_id
}