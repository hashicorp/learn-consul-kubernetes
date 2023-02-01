# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module "dc2" {
  source = "../../environments/terraform/eks"

  datacenter_name = "dc2"
  output_dir      = "~/.kube"
  region          = "ca-central-1"
}
