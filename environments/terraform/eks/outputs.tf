output "kubeconfig" {
  value = pathexpand(format("${var.output_dir}/eks-%s", module.eks))
}
