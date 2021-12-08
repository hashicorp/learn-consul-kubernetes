# Minikube

minikube start --memory 4096
OR
minikube start
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
cd hashicups/consul/minikube
helm install -f config.yaml consul hashicorp/consul --version "0.37.0"
kubectl apply -f two-services/
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"
kubectl get pods
kubectl apply -f api-gw/
kubectl port-forward svc/consul-ui 6443:443
https://localhost:6443/ui/
https://localhost:8444/hashicups
https://localhost:8444/echo

minikube service list
minikube service consul-ui



# Kind
kind create cluster --name dc1
OR
kind create cluster --config=cluster.yaml
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
cd hashicups/consul/kind
helm install -f config.yaml consul hashicorp/consul --version "0.37.0"
kubectl apply -f two-services/
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"
kubectl apply -f api-gw/
kubectl port-forward svc/consul-ui 6443:443
https://localhost:6443/ui/
https://localhost:8444/hashicups
https://localhost:8444/echo

kubectl port-forward svc/test-gateway 8444:8444

# Apply crds - this applies the CRDs and creates the gateway controller 
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"
