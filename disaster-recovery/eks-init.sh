# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

kubectl config rename-context eks_dc1 dc1
kubectl config rename-context eks_dc2 dc2

kubectl config use-context dc1