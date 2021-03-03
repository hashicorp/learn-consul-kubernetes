VAULT_ADDR=$1
VAULT_TOKEN=$2

kubectl config use-context dc1

kubectl get secret consul-federation -o yaml > ./dc2/consul-federation-secret.yaml

kubectl config use-context dc2

kubectl apply -f ./dc2/consul-federation-secret.yaml

cat <<EOF > ./dc2/ca-config.json
{
  "connect": [
    {
      "ca_config": [
        {
          "address": "$VAULT_ADDR",
          "intermediate_pki_path": "dc2/connect-intermediate",
          "root_pki_path": "connect-root",
          "token": "$VAULT_TOKEN"
        }
      ],
      "ca_provider": "vault"
    }
  ]
}
EOF

kubectl create secret generic vault-config --from-file=config=./dc2/ca-config.json

helm install consul hashicorp/consul -f ./dc2/dc2-values.yaml --version "0.30.0" --wait