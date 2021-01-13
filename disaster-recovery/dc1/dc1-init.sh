VAULT_ADDR=$1
VAULT_TOKEN=$2

mkdir -p dc1/backup
mkdir -p dc1/secrets

kubectl config use-context dc1

cat <<EOF > ca-config.json
{
  "connect": [
    {
      "ca_config": [
        {
          "address": "$VAULT_ADDR",
          "intermediate_pki_path": "dc1/connect-intermediate",
          "root_pki_path": "connect-root",
          "token": "$VAULT_TOKEN"
        }
      ],
      "ca_provider": "vault"
    }
  ]
}
EOF

kubectl create secret generic vault-config --from-file=config=ca-config.json

kubectl create secret generic consul-gossip-encryption-key --from-literal=key=$(consul keygen)

helm install consul hashicorp/consul -f dc1-values.yaml --wait

kubectl apply -f postgres.yaml

kubectl apply -f product-api.yaml

export CONSUL_TOKEN=$(kubectl get secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -D)

kubectl exec consul-server-0 -- consul intention create -token $CONSUL_TOKEN product-api postgres


