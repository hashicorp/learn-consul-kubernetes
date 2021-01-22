module "dc1" {
  source = "../../environments/terraform/eks"

  datacenter_name = "dc1"
  output_dir = "~/.kube"
}