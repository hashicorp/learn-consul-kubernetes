# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# The identity of the AWS User running this terraform project
data "aws_caller_identity" "current" {}