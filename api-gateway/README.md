# Kind
1. Clone repo
2. `cd api-gateway/`
3. `kind create cluster --config=kind/cluster.yaml`
4. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0"`
5. `helm repo add hashicorp https://helm.releases.hashicorp.com`
6. `helm repo update`
7. `helm install -f consul/config.yaml consul hashicorp/consul --version "0.41.1"`
8. `kubectl apply --filename two-services`
9.  `kubectl apply --filename api-gw/consul-api-gateway.yaml && kubectl wait --for=condition=ready gateway/example-gateway --timeout=90s && kubectl apply --filename api-gw/routes.yaml` 
10.  `kubectl port-forward svc/consul-ui 6443:443`
11. Visit the following urls in the browser
    1.  [https://localhost:6443/ui/](https://localhost:6443/ui/)
    2.  [https://localhost:8443/hashicups](https://localhost:8443/hashicups)
    3.  [https://localhost:8443/echo](https://localhost:8443/echo)
