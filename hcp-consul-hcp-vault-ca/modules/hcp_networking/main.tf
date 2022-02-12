# From HCP, creating a peering relationship that generates the pcx-id in AWS.
resource "hcp_aws_network_peering" "default" {
  hvn_id          = var.hvn_name
  peer_vpc_id     = var.aws_vpc_id
  peer_vpc_region = var.aws_region
  peer_account_id = var.aws_account_id
  peering_id      = var.hvn_peering_identifier
}


# HCP creates the peering relationship in the default route table
resource "aws_route" "hcp_peering_private" {
  count = length(var.private_route_table_ids)
  route_table_id = var.private_route_table_ids[count.index]
  vpc_peering_connection_id = hcp_aws_network_peering.default.provider_peering_id
  destination_cidr_block = var.hcp_hvn_cidr_block
}

resource "aws_route" "hcp_peering_public" {
  count = length(var.public_route_table_ids)
  route_table_id = var.public_route_table_ids[count.index]
  vpc_peering_connection_id = hcp_aws_network_peering.default.provider_peering_id
  destination_cidr_block = var.hcp_hvn_cidr_block
}

# Create an accepter from the hcp_aws_network_peering pcx-id
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.default.provider_peering_id
  auto_accept = true
}

# Create an hcp route that that has a destination CIDR of the AWS VPC
resource "hcp_hvn_route" "peering_route" {
  hvn_link = var.hvn_link
  hvn_route_id = "${var.hvn_name}-peering"
  destination_cidr = var.aws_vpc_cidr_block
  target_link = hcp_aws_network_peering.default.self_link
  depends_on = [aws_vpc_peering_connection_accepter.peer]

}

# Create an AWS Route that
resource "aws_route" "peering-public" {
  route_table_id = var.vpc_default_route_table_id
  destination_cidr_block = var.hcp_hvn_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.vpc_peering_connection_id
}
