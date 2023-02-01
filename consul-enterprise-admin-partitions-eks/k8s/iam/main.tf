# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  # user_data2
  assume_policy = file("${path.module}/config/assume_role_policy.json")
}

locals {
  # user_data
  open_policy = file("${path.module}/config/policy.json")
}




