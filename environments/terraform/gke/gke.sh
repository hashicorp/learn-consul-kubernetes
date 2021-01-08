# GKE

terraform init
echo "${GOOGLE_CREDENTIALS}" | gcloud auth activate-service-account --key-file=-

terraform apply -var project=${CLOUDSDK_CORE_PROJECT} -var init_cli=true -var cluster_count=2 -auto-approve

eval "$(echo export primary_kubeconfig=$(terraform output -state ../../terraform/gke/terraform.tfstate -json | jq -r .kubeconfigs.value[0]))"
eval "$(echo export secondary_kubeconfig=$(terraform output -state ../../terraform/gke/terraform.tfstate -json | jq -r .kubeconfigs.value[1]))"

terraform destroy -var project=${CLOUDSDK_CORE_PROJECT} -auto-approve

