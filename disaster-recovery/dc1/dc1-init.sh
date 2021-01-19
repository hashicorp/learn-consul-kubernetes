VAULT_ADDR=$1
VAULT_TOKEN=$2

mkdir -p dc1/backup
mkdir -p dc1/secrets

helm repo update

# ensure rename occurred for all scenarios
kubectl config rename-context kind-dc1 dc1
kubectl config rename-context eks_dc1 dc1

kubectl config use-context dc1

cat <<EOF > ./dc1/ca-config.json
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

kubectl create secret generic vault-config --from-file=config=./dc1/ca-config.json

kubectl create secret generic consul-gossip-encryption-key --from-literal=key=$(consul keygen)

helm install consul hashicorp/consul -f ./dc1/dc1-values.yaml --version "0.28.0" --wait


