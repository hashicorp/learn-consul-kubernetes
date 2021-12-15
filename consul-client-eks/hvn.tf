resource "hcp_hvn" "server" {
  hvn_id         = "${var.hvn_name}-${local.suffix}"
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = var.hcp_hvn_cidr
}