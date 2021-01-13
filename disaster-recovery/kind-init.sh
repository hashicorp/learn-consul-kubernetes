kind create cluster --name dc1

kind create cluster --name dc2

kubectl config rename-context kind-dc1 dc1

kubectl config rename-context kind-dc2 dc2

kubectl config use-context dc1

kubectl config get-contexts
