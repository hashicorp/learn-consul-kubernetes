helm repo add jaegertracing https://jaegertracing.github.io/helm-charts

helm repo udpate

kind create cluster --name hashicups-jaeger

helm install -f ./helm/consul.yaml consul hashicorp/consul --version "0.30.0" --wait

kubectl apply -f proxy-defaults.yaml

helm install jaeger jaegertracing/jaeger-operator --wait

kubectl apply -f ./helm/jaeger.yaml --wait

kubectl apply -f ./ --wait