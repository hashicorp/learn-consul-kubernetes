#!/usr/bin/env bash
# This script captures the cluster's ca-cert and key
# to generate a certificate for this machine
# to access the Consul Enterprise instance
# via consul proxy. It also sets the Consul HTTP token
# that can be used to authenticate to the Consul UI.
set -e


CONTEXT=${CONSUL_PRIMARY}

kubectl get secret server-ca-cert --context ${CONTEXT} -o json | jq '.data["tls.crt"]' | sed 's/"//g' | base64 --decode > "${HOME}"/.consul_ca_cert.crt
kubectl get secret server-ca-key --context ${CONTEXT} -o json | jq '.data["tls.key"]' | sed 's/"//g' | base64 --decode > "${HOME}"/.consul_client-ca.pem
openssl req -new -newkey rsa:2048 -nodes -keyout "${HOME}"/.local.key -out "${HOME}"/.local.csr -subj "/CN=local.consul"
consul_http_token=$(kubectl get secret server-bootstrap-acl-token --context "${CONTEXT}" -o json | jq -r '.data.token' | base64 --decode)

openssl x509 -req -in "${HOME}"/.local.csr -CA "${HOME}"/.consul_ca_cert.crt -CAkey "${HOME}"/.consul_client-ca.pem -CAcreateserial -out "${HOME}"/.local.srl -out "${HOME}"/.local.crt
if [[ -f "${HOME}"/.consulrc ]]; then
 echo "" > "${HOME}"/.consulrc
fi

echo "export CONSUL_CLIENT_KEY=${HOME}/.local.key" >> "${HOME}"/.consulrc
echo "export CONSUL_HTTP_ADDR=https://127.0.0.1:8501" >> "${HOME}"/.consulrc
echo "export CONSUL_CACERT=${HOME}/.consul_ca_cert.crt" >> "${HOME}"/.consulrc
echo "export CONSUL_CLIENT_CERT=${HOME}/.local.crt" >> "${HOME}"/.consulrc
echo "export CONSUL_HTTP_TOKEN=$consul_http_token" >> "${HOME}"/.consulrc
exit 0
