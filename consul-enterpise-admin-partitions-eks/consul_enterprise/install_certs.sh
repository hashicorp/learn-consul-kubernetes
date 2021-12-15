#!/usr/bin/env bash
# This script captures the cluster's ca-cert and key
# to generate a certificate for this machine
# to access the Consul Enterprise instance
# via consul proxy
set -e


CONTEXT="united_federation_of_planets"

kubectl get secret consul-ca-cert --context ${CONTEXT} -o json | jq '.data["tls.crt"]' | sed 's/"//g' | base64 --decode > "${HOME}"/.consul_ca_cert.crt
kubectl get secret consul-ca-key --context ${CONTEXT} -o json | jq '.data["tls.key"]' | sed 's/"//g' | base64 --decode > "${HOME}"/.consul_client-ca.pem
openssl req -new -newkey rsa:2048 -nodes -keyout "${HOME}"/.local.key -out "${HOME}"/.local.csr -subj "/CN=local.consul"

openssl x509 -req -in "${HOME}"/.local.csr -CA "${HOME}"/.consul_ca_cert.crt -CAkey "${HOME}"/.consul_client-ca.pem -CAcreateserial -out "${HOME}"/.local.srl -out "${HOME}"/.local.crt
if [[ -f "${HOME}"/.consulrc ]]; then
 echo "" > "${HOME}"/.consulrc
fi
echo "export CONSUL_CLIENT_KEY=${HOME}/.local.key" >> "${HOME}"/.consulrc
echo "export CONSUL_HTTP_ADDR=https://127.0.0.1:8501" >> "${HOME}"/.consulrc
echo "export CONSUL_CACERT=${HOME}/.consul_ca_cert.crt" >> "${HOME}"/.consulrc
echo "export CONSUL_CLIENT_CERT=${HOME}/.local.crt" >> "${HOME}"/.consulrc
exit 0