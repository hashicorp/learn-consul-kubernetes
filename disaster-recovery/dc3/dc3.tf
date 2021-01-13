module "dc3" {
  source = "../../environments/terraform/eks"

  datacenter_name = "dc3"
  output_dir = "~/.kube"
}