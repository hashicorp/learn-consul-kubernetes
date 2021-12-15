variable "vpc_id_requester" {}
variable "vpc_id_accepter" {}

resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = var.vpc_id_accepter
  peer_vpc_id = var.vpc_id_requester
  auto_accept = true
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.peering.id
}