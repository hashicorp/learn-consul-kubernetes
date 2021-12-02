# Minikube

cd hashicups/consul/minikube
helm install -f config.yaml consul hashicorp/consul
minikube service list
minikube service consul-ui


# Kind
kind create cluster --name dc1
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
cd hashicups/consul/kind
helm install -f config.yaml consul hashicorp/consul --version "0.37.0"
kubectl apply -f dev/config/hashicups/two-services/
kubectl apply -f dev/config/hashicups/api-gw/