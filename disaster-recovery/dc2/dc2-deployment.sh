# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

CONSUL_TOKEN=$1

kubectl config use-context dc2

kubectl apply -f ./dc2/public-api.yaml

kubectl apply -f ./dc2/frontend.yaml

kubectl exec consul-server-0 -- consul intention create -token $CONSUL_TOKEN frontend public-api

kubectl exec consul-server-0 -- consul intention create -token $CONSUL_TOKEN public-api product-api

kubectl config use-context dc1