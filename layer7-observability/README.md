## Tutorial URL

https://learn.hashicorp.com/tutorials/consul/kubernetes-layer7-observability


## procedure
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
helm repo add grafana https://grafana.github.io/helm-charts && \
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts && \
helm repo update

helm install --values helm/consul-values.yaml consul hashicorp/consul --version "0.43.0"
helm install --values helm/jaeger-values.yaml jaeger jaegertracing/jaeger --version "0.57.1"
helm install --values helm/prometheus-values.yaml prometheus prometheus-community/prometheus --version "15.5.3"
helm install --values helm/grafana-values.yaml grafana grafana/grafana --version "6.23.1"

helm install --values helm/jaeger-simple.yaml jaeger jaegertracing/jaeger --version "0.57.1"

helm install --values helm/jaeger-simplest.yaml jaeger jaegertracing/jaeger --version "0.57.1"

kubectl apply -f hashicups/

kubectl apply -f traffic.yaml

kubectl get pods

kubectl port-forward deploy/jaeger-query 8090:16686
kubectl port-forward deploy/prometheus-server 9090:9090
kubectl port-forward deploy/frontend 8080:80
kubectl port-forward consul-server-0 8500:8500

kubectl port-forward deploy/nginx 8080:80


## Troubleshooting / Testing
kubectl exec --stdin --tty consul-server-0 -- /bin/sh
kubectl exec --stdin --tty svc/product-api -- /bin/sh
ping jaeger-collector.default.svc.cluster.local

curl -X POST "http://jaeger-collector.default.svc.cluster.local:9411/api/v2/spans" -H "accept: application/json" -H "content-type: application/json" -d "[ { \"traceId\": \"string\", \"name\": \"string\", \"parentId\": \"string\", \"id\": \"string\", \"kind\": \"CLIENT\", \"timestamp\": 0, \"duration\": 0, \"debug\": true, \"shared\": true, \"localEndpoint\": { \"serviceName\": \"string\", \"ipv4\": \"string\", \"ipv6\": \"string\", \"port\": 0 }, \"remoteEndpoint\": { \"serviceName\": \"string\", \"ipv4\": \"string\", \"ipv6\": \"string\", \"port\": 0 }, \"annotations\": [ { \"timestamp\": 0, \"value\": \"string\" } ], \"tags\": { \"additionalProp1\": \"string\", \"additionalProp2\": \"string\", \"additionalProp3\": \"string\" } }]"

helm repo add opentelemetry-helm https://open-telemetry.github.io/opentelemetry-helm-charts
helm install --values helm/otel-values.yaml opentelemetry-collector opentelemetry-helm/opentelemetry-collector --version 0.25.0


## Testing with Otel
1. Deploy cert-manager
2. Deploy otel operator
3. Deploy otel collector sidecar definition
4. Deploy jaeger operator
5. Deploy jaeger collector
6. Deploy Consul
   1. Try deploying proxy-defaults at one point
7. Add annotations to pod definitions on each HashiCups service
8. Deploy Hashicups

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
kubectl apply -f helm/otel-collector.yaml
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.36.0/jaeger-operator.yaml -n observability
kubectl apply -f helm/jaeger-simplest.yaml
helm install --values helm/consul-values.yaml consul hashicorp/consul --version "0.43.0"
kubectl apply -f proxy-defaults.yaml 
kubectl apply -f hashicups-v2/
helm install --values helm/prometheus-values.yaml prometheus prometheus-community/prometheus --version "15.5.3"

kubectl exec --stdin --tty simplest-8446d7d88f-jdknl -- /bin/sh


## Deploy Prometheus Operator
https://prometheus-operator.dev/docs/prologue/quick-start/
ping simplest-collector.default.svc.cluster.local
ping simplest-collector-headless.default.svc.cluster.local

