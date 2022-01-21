# Kind
1. Clone repo
1. `cd api-gateway/`
2. `kind create cluster --config=kind/cluster.yaml`
3. `helm repo add hashicorp https://helm.releases.hashicorp.com`
4. `helm repo update`
5. `helm install -f consul/config.yaml consul hashicorp/consul --version "0.39.0"`
6. `kubectl apply -f two-services/`
7. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"`
   1. new: `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-beta"`
8. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"`
   1. new: `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-beta"`
   2. Alternative (for testing): `kubectl apply -k "../../consul-api-gateway/config"`
9.  `kubectl apply -f api-gw/consul-api-gateway.yaml && kubectl wait --for=condition=ready gateway/test-gateway --timeout=90s && kubectl apply -f api-gw/routes.yaml` 
    1.  note: race condition
    2.  note: deploying routes 2nd, best practice
10. `kubectl port-forward svc/consul-ui 6443:443`
11. Visit the following in the browser
- [https://localhost:6443/ui/](https://localhost:6443/ui/)
- [https://localhost:8443/hashicups](https://localhost:8443/hashicups)
- [https://localhost:8443/echo](https://localhost:8443/echo)
- Note: Currently the hashicups and echo services are routing correctly because `useHostPorts: true` is set in `consul-api-gateway.yaml`. A more secure practice would be to replace `useHostPorts` with `serviceType: ClusterIP` or `serviceType: NodePort`, however this currently does not function as expected - when set, the `port-forward` operation fails to forward the traffic through the API Gateway. This is being looked into by the API Gateway team.
