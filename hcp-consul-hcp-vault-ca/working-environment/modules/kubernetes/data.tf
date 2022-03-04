data "local_file" "kube_config" {
  filename = pathexpand("~/.kube/config")
}