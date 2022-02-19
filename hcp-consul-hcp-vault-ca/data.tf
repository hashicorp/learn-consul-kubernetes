data "aws_caller_identity" "current" {}
data "local_file" "kube_config" {
  filename = pathexpand("~/.kube/config")
  depends_on = [null_resource.update_kubeconfig]
}