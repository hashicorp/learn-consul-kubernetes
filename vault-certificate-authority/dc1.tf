module "dc1" {
  source = "../environments/terraform/eks"

  datacenter_name = "dc1"
  region = "us-east-2"
  output_dir = "~/.kube"
}