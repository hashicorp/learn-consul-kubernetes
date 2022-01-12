#!/usr/bin/env bash

set -e

SECONDARY=${CURRENT_KUBE_CONTEXT}
PRIMARY=${CONSUL_PRIMARY}
CONSUL_DEPLOY_TYPE=${CONSUL_DEPLOY_TYPE}

if [ "${CONSUL_DEPLOY_TYPE}" = "server" ]; then
  #kubectl config use-context "${PRIMARY}"
  kubectl delete -f ./hashicups/crds/proxydefaults-all.yaml --context "${PRIMARY}" --ignore-not-found || true
  kubectl delete -f ./hashicups/crds/crd-exported-service-"${PRIMARY}".yaml --context "${PRIMARY}" --ignore-not-found || true
  #kubectl delete -f ./hashicups/crds/crd-intentions.yaml --context "${PRIMARY}" --ignore-not-found || true
  kubectl delete -f ./hashicups/postgres.yaml --context "${PRIMARY}" --ignore-not-found || true
  #helm uninstall --wait hashicorp-"${CONSUL_DEPLOY_TYPE}" || true
else
  #kubectl config use-context "${SECONDARY}"
  kubectl delete -f ./hashicups/crds/proxydefaults-all.yaml --context "${SECONDARY}" --ignore-not-found || true
  #kubectl delete -f ./hashicups/crds/crd-exported-service-"${SECONDARY}".yaml --context "${SECONDARY}" --ignore-not-found || true
  #kubectl delete -f ./hashicups/crds/crd-intentions.yaml --context "${SECONDARY}" --ignore-not-found || true
  #kubectl delete -f ./hashicups/frontend.yaml --context "${SECONDARY}" --ignore-not-found || true
  #kubectl delete -f ./hashicups/payments.yaml --context "${SECONDARY}" --ignore-not-found || true
  #kubectl delete -f ./hashicups/public-api.yaml --context "${SECONDARY}" --ignore-not-found || true
  #kubectl delete -f ./hashicups/products-api.yaml --context "${SECONDARY}" --ignore-not-found || true
  #helm uninstall --wait hashicorp-"${CONSUL_DEPLOY_TYPE}" || true
  kubectl get secrets | grep -i "client-" | grep -v "server-client" | awk \{'print $1'\} | xargs kubectl delete --context "${SECONDARY}" secrets || true
fi