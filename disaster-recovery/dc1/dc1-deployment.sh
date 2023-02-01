# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

kubectl apply -f ./dc1/postgres.yaml

kubectl apply -f ./dc1/product-api.yaml

export CONSUL_TOKEN=$(kubectl get secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -D)

kubectl exec consul-server-0 -- consul intention create -token $CONSUL_TOKEN product-api postgres