#!/usr/bin/env bash

set -e

SECONDARY=${CURRENT_KUBE_CONTEXT}
PRIMARY=${CONSUL_PRIMARY}
CONSUL_DEPLOY_TYPE=${CONSUL_DEPLOY_TYPE}

if [ "${CONSUL_DEPLOY_TYPE}" = "server" ]; then
  helm install --wait hashicorp-"${CONSUL_DEPLOY_TYPE}" hashicorp/consul -f consul-values-"${CONSUL_DEPLOY_TYPE}".yaml
else
  kubectl config use-context "${PRIMARY}"

  kubectl get secret consul-bootstrap-acl-token --context "${PRIMARY}" -o yaml | kubectl apply --context "${SECONDARY}" -f -
  kubectl get secret consul-ca-key --context "${PRIMARY}" -o yaml | kubectl apply --context "${SECONDARY}" -f -
  kubectl get secret consul-ca-cert --context "${PRIMARY}" -o yaml | kubectl apply --context "${SECONDARY}" -f -
  PartitionIp=$(kubectl get svc | grep -i "LoadBalancer" | awk \{'print $4'\})
  yq e ".client.join = [\"${PartitionIp}\"]" -i ./consul-values-"${CONSUL_DEPLOY_TYPE}".yaml
  yq e ".externalServers.hosts = [\"${PartitionIp}\"]" -i ./consul-values-"${CONSUL_DEPLOY_TYPE}".yaml
  kubectl config use-context "${SECONDARY}"
  helm install --wait hashicorp-"${CONSUL_DEPLOY_TYPE}" hashicorp/consul -f ./consul_enterprise/consul-values-"${CONSUL_DEPLOY_TYPE}".yaml
fi