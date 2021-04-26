module "dc1" {
  source = "../../environments/terraform/eks"

  datacenter_name = "mesh-gateways-dc2"
  region = "us-west-2"
  output_dir = "./"
}