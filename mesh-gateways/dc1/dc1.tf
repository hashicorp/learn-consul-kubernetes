module "dc1" {
  source = "../../environments/terraform/eks"

  datacenter_name = "mesh-gateways-dc1"
  region = "us-east-2"
  output_dir = "./"
}