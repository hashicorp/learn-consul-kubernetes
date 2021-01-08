####################################
# Prep development machine
####################################
export WORKING_DIR="./"
export CLOUD_PROVIDER="eks"
# export CLOUD_PROVIDER="aks"
# export CLOUD_PROVIDER="gke"
mkdir -p $WORKING_DIR/dc1/backup
mkdir -p $WORKING_DIR/dc2/backup

if [ $CLOUD_PROVIDER = "eks" ]; then
  # Requires that you are logged into the AWS CLI and have the aws-iam-authenticator installed
# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
  brew update && brew install aws-iam-authenticator
fi

####################################
# Vault setup
####################################

# start vault

#################################### TODO: Make this dynamic
vault server -dev

# in a separate tab use ngrok to obtain a public address:
ngrok http 8200

# export the vault token and ngrok address for your installation:
export VAULT_TOKEN="s.YwbvCrFTsNZ7xAQOvZ6qM2PW"
export VAULT_ADDR="http://01abc22df39f.ngrok.io"

cat <<EOF > $WORKING_DIR/dc1/ca-config.json
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

####################################
# Create AWS kubernetes environments
####################################
terraform init
terraform apply -auto-approve

export KUBECONFIG=$WORKING_DIR/$CLOUD_PROVIDER-dc1:$WORKING_DIR/$CLOUD_PROVIDER-dc2

####################################
# Setup Primary DC
####################################
kubectl config use-context ${CLOUD_PROVIDER}-dc1

# Vault config
kubectl create secret generic vault-config --from-file=config=$WORKING_DIR/dc1/ca-config.json

# Gossip Encryption Key
kubectl create secret generic consul-gossip-encryption-key --from-literal=key=$(consul keygen)

# Add helm repo
helm repo add hashicorp https://helm.releases.hashicorp.com

# Update helm
helm repo update

# install Consul in Primary DC
helm install consul hashicorp/consul -f dc1/dc1.yaml --version "0.27.0" --wait

# deploy TODO: Move to HashiCups
kubectl apply -f dc1/static-client.yaml

# get bootstrap token
export CONSUL_TOKEN=$(kubectl get secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -D)

#Export federation secret
kubectl get secret consul-federation -o yaml > $WORKING_DIR/dc2/consul-federation-secret.yaml

###################################
# Setup Secondary DC
###################################
kubectl config use-context $CLOUD_PROVIDER-dc2

# Add federation secret
kubectl apply -f dc2/consul-federation-secret.yaml

# Setup dc2 Vault config
cat <<EOF > $WORKING_DIR/dc2/ca-config.json
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

# Add Vault config as secret
kubectl create secret generic vault-config --from-file=config=dc2/ca-config.json

# Install Consul
helm install consul hashicorp/consul -f $WORKING_DIR/dc2/dc2-helm-values.yaml --wait

## Validate Federation
kubectl exec statefulset/consul-server -- consul members -wan
kubectl exec statefulset/consul-server -- consul catalog services -datacenter dc1

# Deploy backend
kubectl apply -f $WORKING_DIR/dc2/static-server.yaml

# Test
kubectl config use-context $CLOUD_PROVIDER-dc1

# create intention to allow communications TODO:
kubectl exec consul-server-0 -- consul intention create -token $CONSUL_TOKEN static-client static-server

# Test
kubectl exec static-client -c static-client -- curl -sS http://localhost:1234
# expects "hello world"



