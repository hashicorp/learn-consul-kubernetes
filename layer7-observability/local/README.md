# Consul API Gateway with Kind

1. Clone repo
2. `cd api-gateway/local/`
3. `kind create cluster --config=kind/cluster.yaml`
4. `kubectl apply -k "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.3.0"`
5. `helm repo add hashicorp https://helm.releases.hashicorp.com`
6. `helm repo update`
7. Install Consul
    1. Helm: 
    `helm install --values consul/config.yaml consul hashicorp/consul --create-namespace --namespace consul --version "0.45.0"`
    2. Consul K8S:
    `consul-k8s install -config-file=consul/config.yaml -set global.image=hashicorp/consul:1.12.2`
8. `kubectl apply --filename two-services`
9.  `kubectl apply --filename api-gw/consul-api-gateway.yaml --namespace consul && kubectl wait --for=condition=ready gateway/api-gateway --namespace consul --timeout=90s && kubectl apply --filename api-gw/routes.yaml --namespace consul` 
10.  `kubectl port-forward svc/consul-ui --namespace consul 6443:443`
11. Visit the following urls in the browser
    1.  [https://localhost:6443/ui/](https://localhost:6443/ui/)
    2.  [https://localhost:8443/hashicups](https://localhost:8443/hashicups)
    3.  [https://localhost:8443/echo](https://localhost:8443/echo)


## README - install

kind create cluster --config=kind/cluster.yaml
helm install --values helm/consul-v1.yaml consul hashicorp/consul --create-namespace --namespace consul --version "0.46.1"
kubectl apply --filename hashicups/v1/
kubectl port-forward svc/consul-ui --namespace consul 6443:443
[Consul UI](https://localhost:6443/ui/)
kubectl port-forward svc/nginx --namespace default 3000:80
[HashiCups UI](http://localhost:3000/)

## README - ingress

kubectl apply --kustomize "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.3.0"
helm upgrade --values helm/consul-v2.yaml consul hashicorp/consul --namespace consul --version "0.46.1"
kubectl apply --filename api-gw/v1/consul-api-gateway.yaml --namespace consul && \
 kubectl wait --for=condition=ready gateway/api-gateway --namespace consul --timeout=90s && \
 kubectl apply --filename api-gw/v1/routes.yaml --namespace consul
kubectl port-forward svc/consul-ui --namespace consul 6443:443
[Consul UI](https://localhost:6443/ui/)
[HashiCups UI](https://localhost:8443/)

## README - observability

helm upgrade --values helm/consul-v3.yaml consul hashicorp/consul --namespace consul --version "0.46.1"

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
# wait 15 seconds
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.56.0/opentelemetry-operator.yaml
# wait 15 seconds
kubectl apply -f helm/otel-collector.yaml
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.36.0/jaeger-operator.yaml -n observability
# wait 15 seconds
kubectl apply -f helm/jaeger-allinone.yaml
helm install --values helm/prometheus-stack.yaml prometheus prometheus-community/prometheus --version "15.5.3"
# wait 15 seconds
helm install --values helm/grafana.yaml grafana grafana/grafana --version "6.23.1"
helm upgrade --values helm/consul-v3.yaml consul hashicorp/consul --namespace consul --version "0.46.1"

kubectl apply --kustomize "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.3.0"
kubectl create namespace consul
helm install --values helm/consul-v3.yaml consul hashicorp/consul --namespace consul --version "0.46.1"

kubectl apply -f proxy-defaults.yaml 
kubectl apply -f hashicups/v3/

kubectl port-forward svc/consul-ui --namespace consul 6443:443
[Consul UI](https://localhost:6443/ui/)
kubectl port-forward svc/grafana --namespace default 3000:3000
[Grafana UI](http://localhost:3000/)
kubectl port-forward svc/simplest-query --namespace default 9999:16686
[Jaeger UI](http://localhost:9999/)
kubectl port-forward svc/prometheus-server --namespace default 8888:80
[Prometheus UI](http://localhost:8888/)
kubectl port-forward svc/nginx --namespace default 3000:80
[HashiCups UI](http://localhost:3000/)

kubectl port-forward svc/simplest-query 9999:16686


## alt test

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
kubectl apply -f helm/otel-collector.yaml
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.36.0/jaeger-operator.yaml -n observability
kubectl apply -f helm/jaeger-simplest.yaml
helm install --values helm/consul-values.yaml consul hashicorp/consul --version "0.43.0"
kubectl apply -f proxy-defaults.yaml 
kubectl apply -f hashicups-v2/
helm install --values helm/prometheus-stack.yaml prometheus prometheus-community/prometheus --version "15.5.3"


## alt test 2

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
# wait 15 seconds
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.56.0/opentelemetry-operator.yaml
# wait 15 seconds
kubectl apply -f helm/otel-collector-test.yaml
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.36.0/jaeger-operator.yaml -n observability
# wait 15 seconds
kubectl apply -f helm/jaeger-allinone.yaml
helm install --values helm/loki-stack.yaml loki grafana/loki-stack
kubectl port-forward svc/loki-grafana 3000:80
kubectl get secret --namespace default loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

kubectl apply --kustomize "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.3.0"
kubectl create namespace consul
helm install --values helm/consul-v3.yaml consul hashicorp/consul --namespace consul --version "0.46.1"

kubectl apply -f proxy-defaults.yaml 
kubectl apply -f hashicups/v3/

kubectl port-forward svc/consul-ui --namespace consul 6443:443
[Consul UI](https://localhost:6443/ui/)
kubectl port-forward svc/grafana --namespace default 3000:3000
[Grafana UI](http://localhost:3000/)
kubectl port-forward svc/simplest-query --namespace default 9999:16686
[Jaeger UI](http://localhost:9999/)
kubectl port-forward svc/prometheus-server --namespace default 8888:80
[Prometheus UI](http://localhost:8888/)
kubectl port-forward svc/nginx --namespace default 3000:80
[HashiCups UI](http://localhost:3000/)

kubectl port-forward svc/simplest-query 9999:16686

# public api - not exposing/merging metrics
kubectl exec -it public-api-78f66bddd8-wjhbh -c public-api -- wget -qO- 127.0.0.1:20200/metrics | tail -n 10
# frontend - not exposing/merging metrics
kubectl exec -it frontend-54bd899c74-tn2s8 -c frontend -- wget -qO- 127.0.0.1:20200/metrics | tail -n 10

# product api - SUCCESS !
kubectl exec -it product-api-7665d5c597-l9tqr -c product-api -- wget -qO- 127.0.0.1:20200/metrics | tail -n 10

# product api db - SUCCESS !
kubectl exec -it product-api-db-c99d599f6-8svff  -c postgres-exporter -- wget -qO- 127.0.0.1:20200/metrics | tail -n 10

# payments - SUCCESS !
kubectl exec -it payments-6fc9d744f4-8l6jg -c payments -- wget -qO- 127.0.0.1:20200/metrics | tail -n 10

# nginx - SUCCESS !
kubectl exec -it nginx-65d59b8f9b-z7v4w  -c nginx -- wget -qO- 127.0.0.1:20200/metrics | tail -n 10



kubectl exec --stdin --tty public-api-768fc7dc95-d2w7m -c envoy-sidecar -- /bin/sh

kubectl exec --stdin --tty public-api-78f66bddd8-wjhbh -c public-api -- /bin/sh
kubectl exec --stdin --tty product-api-7665d5c597-l9tqr -- /bin/sh