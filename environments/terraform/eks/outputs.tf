output "kubeconfig" {
  value = pathexpand(format("${var.output_dir}/%s", module.eks))
}
