  # AKS

# Running this terraform job will require you to provide an Azure Service Principal Client ID and Client Secret.
# The script assumes you have saved the values as environment variables on your development host. For information
# on how to create an Azure Service Principal and retrieve the client credentials visit this page.
# https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal

# Set here or in bashrc/zshrc
# export ARM_CLIENT_ID=some.guid
# export ARM_CLIENT_SECRET=some.jwt

init () {
  terraform init
  terraform apply -var subscription_id="$ARM_SUBSCRIPTION_ID" -var tenant_id="$ARM_TENANT_ID" -var client_id="$ARM_CLIENT_ID" -var client_secret="$ARM_CLIENT_SECRET" -var cluster_count=2 -auto-approve
}

kubeconfig () {
  export primary_kubeconfig=$(terraform output -state ./terraform.tfstate -json | jq -r .kubeconfigs.value[0])
  export secondary_kubeconfig=$(terraform output -state ./terraform/aks/terraform.tfstate -json | jq -r .kubeconfigs.value[1])
}

destroy () {
  terraform destroy -auto-approve
}

