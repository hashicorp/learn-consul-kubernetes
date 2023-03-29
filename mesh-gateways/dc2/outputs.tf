# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "kubeconfig_filename" {
  value = abspath(module.eks.kubeconfig_filename)
}