## Setup

`sh ./init.sh`

## Viewing UI

`kubectl port-forward deploy/frontend 8080:80`

## Viewing Jaeger metrics

`kubectl port-forward deploy/jaeger 16686:16686`

## Tear down

`kind delete cluster --name hashicups-jaeger`