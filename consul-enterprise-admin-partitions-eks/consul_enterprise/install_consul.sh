#!/usr/bin/env bash

set -e

SECONDARY=${CURRENT_KUBE_CONTEXT}
PRIMARY=${CONSUL_PRIMARY}
CONSUL_DEPLOY_TYPE=${CONSUL_DEPLOY_TYPE}

if [ "${CONSUL_DEPLOY_TYPE}" = "server" ]; then
  helm install --wait hashicorp-"${CONSUL_DEPLOY_TYPE}" hashicorp/consul -f ./consul-values-"${CONSUL_DEPLOY_TYPE}".yaml
else
  kubectl config use-context "${PRIMARY}"

  PartitionIp=$(kubectl get svc | grep -i "LoadBalancer" | awk \{'print $4'\})
  #TERM=dumb removes ANSI color coding from this command. See: https://github.com/kubernetes/kubernetes/issues/5698#issuecomment-566125254
  ControlPlaneHost=$(TERM=dumb kubectl --context "${SECONDARY}" cluster-info | grep -i "kubernetes control plane" | awk \{'print $NF'\})
fi