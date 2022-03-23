output "kubeconfig_filename" {
  value = abspath(module.eks.kubeconfig_filename)
}