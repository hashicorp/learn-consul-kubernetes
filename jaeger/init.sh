helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add hashicorp https://helm.releases.hashicorp.com

helm repo update


kind delete cluster --name hashicups-jaeger
kind create cluster --name hashicups-jaeger --config ./helm/kind.yaml

helm install -f ./helm/consul.yaml consul hashicorp/consul --version "0.30.0" --wait
kubectl apply -f proxy-defaults.yaml

helm install jaeger jaegertracing/jaeger-operator --version "2.19.1" --wait
helm upgrade -i jaeger-operator jaegertracing/jaeger-operator --wait


kubectl apply -f ./helm/jaeger.yaml --wait
kubectl apply -f ./ --wait
