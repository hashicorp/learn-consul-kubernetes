# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "kubeconfig" {
  value = pathexpand(format("${var.output_dir}/%s", module.eks))
}
