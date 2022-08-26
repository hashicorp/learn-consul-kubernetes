#!/usr/bin/env bash
export WORKBENCH=$(kubectl get pods -l app=tutorial  -o json | jq -r ".items[0].metadata.name")
rc =$(echo $?)

if [ $rc -ne 0 ]
then
  echo "Workbench Pod not found. Use kubectl manually, or try again in a moment"
  exit 1
fi

echo	"Confirming access to Kubernetes resources"
kubectl exec -it "${WORKBENCH}" -- kubectl get pods --all-namespaces >/dev/null
krc=$(echo $?)
sleep 2
echo	"Confirming access to HCP Consul"
kubectl exec -it "${WORKBENCH}" -- consul members >/dev/null
crc=$(echo $?)
sleep 2
echo	"Confirming access to HCP Vault"
kubectl exec -it "${WORKBENCH}" -- vault status >/dev/null
vrc=$(echo $?)
if [ $krc -ne 0 ] || [ $crc -ne 0 ] || [ $vrc -ne 0 ]
then
  echo "Access failed to one or more resources."
  echo "Kubernetes returned: $krc"
  echo "Consul returned $crc"
  echo "Vault returned $vrc"
  exit 1
else
  echo "Access confirmed!"
  exit 0
fi
