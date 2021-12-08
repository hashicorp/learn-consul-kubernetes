# Minikube

minikube start --memory 4096
OR
minikube start --config=cluster.yaml
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
cd hashicups/consul/minikube
helm install -f config.yaml consul hashicorp/consul --version "0.37.0"
kubectl apply -f dev/config/hashicups/two-services/
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"
kubectl get pods
kubectl apply -f dev/config/hashicups/api-gw/
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
kubectl apply -f dev/config/hashicups/two-services/
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"
kubectl apply -f dev/config/hashicups/api-gw/
kubectl port-forward consul-server-0 8500:8500
OR
kubectl port-forward consul-server-0 8501:8501
OR
kubectl port-forward svc/consul-server 8501:8501
kubectl port-forward svc/test-gateway 8443:8443

# Apply crds - this applies the CRDs and creates the gateway controller 
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"
kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"
