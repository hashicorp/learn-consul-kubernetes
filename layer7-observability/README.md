# Overview

This repo contains application and dashboard definitions for the Consul Layer 7
observability with Kubernetes guide located at learn.hashicorp.com

## Kubernetes setup

We've optionally provided a terraform option for
EKS. Once you've authenticated with the AWS CLI, you can run `terraform init`
and then `terraform apply` from this directory to provision an EKS cluster
you can use with this tutorial. Once it completes, you can update your `KUBECONFIG`
file with `aws eks update-kubeconfig --region us-west-2 --name layer7-observability-dc1 --alias dc1`.
You should change your region and name if you overrode the values in `dc1.tf`.
The `--alias` argument is optional, but will ensure the commands in the tutorial
work without modification.

## Tutorial steps

To fully deploy the app run the following scripts in order.

`helm install -f helm/consul-values.yaml consul hashicorp/consul --version "0.32.0" --wait`

`kubectl apply -f helm/proxy-defaults.yaml`

`helm install -f helm/prometheus-values.yaml prometheus prometheus-community/prometheus --version "13.8.0" --wait`

`helm install -f helm/grafana-values.yaml grafana grafana/grafana --version "6.8.3" --wait`

`kubectl apply -f hashicups`

To simulate a load on the application, run `kubectl apply -f traffic.yaml`.
