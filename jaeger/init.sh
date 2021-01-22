helm repo add jaegertracing https://jaegertracing.github.io/helm-charts

helm repo udpate

kind create cluster --name hashicups-jaeger

helm install -f ./helm/consul.yaml consul hashicorp/consul --version "0.28.0" --wait

helm install jaeger jaegertracing/jaeger-operator --wait

kubectl apply -f ./helm/jaeger.yaml --wait

kubectl apply -f ./ --wait