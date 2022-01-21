# Minikube

1. Clone Repo
2. `cd api-gateway`
3. `minikube start`
4. `helm repo add hashicorp https://helm.releases.hashicorp.com`
5. `helm repo update`
6. `helm install -f consul/config.yaml consul hashicorp/consul --version "0.39.0"`
7. `kubectl apply -f two-services/`
8. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"`
9. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"`
10. `kubectl get pods`
11. `kubectl apply -f api-gw/`
12. `kubectl port-forward svc/consul-ui 6443:443`
13. Visit the following in the browser
- [https://localhost:6443/ui/](https://localhost:6443/ui/)
- [https://localhost:8443/hashicups](https://localhost:8444/hashicups)
- [https://localhost:8443/echo](https://localhost:8444/echo)
- Note: Currently the hashicups and echo services are NOT routing correctly in Minikube. This is being looked into by the API Gateway team.

# Kind
1. Clone repo
1. `cd api-gateway/`
1. `kind create cluster --config=kind/cluster.yaml`
1. `helm repo add hashicorp https://helm.releases.hashicorp.com`
1. `helm repo update`
1. `helm install -f consul/config.yaml consul hashicorp/consul --version "0.39.0"`
1. `kubectl apply -f two-services/`
1. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.1.0-techpreview"`
1. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config?ref=v0.1.0-techpreview"`
1. `kubectl apply -f api-gw/`
1. `kubectl port-forward svc/consul-ui 6443:443`
1. Visit the following in the browser
- [https://localhost:6443/ui/](https://localhost:6443/ui/)
- [https://localhost:8444/hashicups](https://localhost:8444/hashicups)
- [https://localhost:8444/echo](https://localhost:8444/echo)
- Note: Currently the hashicups and echo services are routing correctly because `useHostPorts: true` is set in `consul-api-gateway.yaml`. A more secure practice would be to replace `useHostPorts` with `serviceType: ClusterIP` or `serviceType: NodePort`, however this currently does not function as expected - when set, the `port-forward` operation fails to forward the traffic through the API Gateway. This is being looked into by the API Gateway team.
