# Kind
1. Clone repo
1. `cd api-gateway/`
2. `kind create cluster --config=kind/cluster.yaml`
3. `helm repo add hashicorp https://helm.releases.hashicorp.com`
4. `helm repo update`
5. `helm install -f consul/config.yaml consul hashicorp/consul --version "0.40.0"`
6. `kubectl apply -f two-services/`
7. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-beta"`
8. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-beta"`
9.  `kubectl apply -f api-gw/consul-api-gateway.yaml && kubectl wait --for=condition=ready gateway/test-gateway --timeout=90s && kubectl apply -f api-gw/routes.yaml` 
10. `kubectl port-forward svc/consul-ui 6443:443`
11. Visit the following urls in the browser
    1.  [https://localhost:6443/ui/](https://localhost:6443/ui/)
    2.  [https://localhost:8443/hashicups](https://localhost:8443/hashicups)
    3.  [https://localhost:8443/echo](https://localhost:8443/echo)
