# Consul API Gateway with Kind

1. Clone repo
2. `cd api-gateway/local/`
3. `kind create cluster --config=kind/cluster.yaml`
4. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.2.1"`
5. `helm repo add hashicorp https://helm.releases.hashicorp.com`
6. `helm repo update`
7. Install Consul
    1. Helm: 
    `helm install --values consul/config.yaml consul hashicorp/consul --create-namespace --namespace consul --version "0.43.0"`
    2. Consul K8S:
    `consul-k8s install -config-file=consul/config.yaml -set global.image=hashicorp/consul:1.12.0`
8. `kubectl apply --filename two-services`
9.  `kubectl apply --filename api-gw/consul-api-gateway.yaml --namespace consul && kubectl wait --for=condition=ready gateway/api-gateway --namespace consul --timeout=90s && kubectl apply --filename api-gw/routes.yaml --namespace consul` 
10.  `kubectl port-forward svc/consul-ui --namespace consul 6443:443`
11. Visit the following urls in the browser
    1.  [https://localhost:6443/ui/](https://localhost:6443/ui/)
    2.  [https://localhost:8443/hashicups](https://localhost:8443/hashicups)
    3.  [https://localhost:8443/echo](https://localhost:8443/echo)
