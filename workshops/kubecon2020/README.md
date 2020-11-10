# Managing Consul Config Entries as Kubernetes CRDs

All commands in this file assume that you have cloned this repository and are
issuing the commands from the directory that contains this README file. If you
are in a differerent directory, you will have to adjust your paths accordingly.

## Create a test cluster

```shell-session
$ kind create cluster --name hashicups
```

## Install Consul on Kubernetes using the official Helm chart

```shell-session
$ helm install -f ./config.yaml consul hashicorp/consul  --version "0.25.0" --wait
```

## Install the Prometheus Operator

```shell-session
$ helm install -f ../../content/layer7-observability/helm/prometheus-values.yaml prometheus prometheus-community/prometheus --version "11.7.0" --wait
```

## Enable Prometheus by registering a ProxyDefaults config entry

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/proxy-defaults.yaml
```

```shell-session
$ kubectl get proxydefaults
```

```shell-session
$ kubectl describe proxydefaults
```

## Deploy V1 of the workload

```shell-session
$ kubectl apply -f ../../workloads/hashicups
```

## Expose the Consul UI

```shell-session
$ kubectl port-forward consul-server-0 8500:8500
```


## Generate traffic

```shell-session
$ kubectl apply -f ../../content/layer7-observability/traffic.yaml
```

## View traffic in Consul

## Add a service intention with service defaults

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/service-intentions.yaml
```

## Inspect the service intention and service defaults CRDs

```shell-session
$ kubectl get serviceintentions
```

```shell-session
$ kubectl get servicedefaults
```

## Test the intention

Forward the port

```shell-session
$ kubectl port-forward deploy/public-api 8080:8080
```

Send a valid request

```shell-session
$ curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer 3d2c7d1d-a360-4cb2-b275-fc47acc8985d" \
    -d '{"operationName":null,"variables":{},"query":"{\n  coffees {\n    id\n    name\n    image\n    price\n    __typename\n  }\n}\n"}' \
    http://localhost:8080/api
```

Send the wrong header

```shell-session
$ curl -X POST \
    -H "Content-Type: application/json" \
    -H "api-token: 3d2c7d1d-a360-4cb2-b275-fc47acc8985d" \
    -d '{"operationName":null,"variables":{},"query":"{\n  coffees {\n    id\n    name\n    image\n    price\n    __typename\n  }\n}\n"}' \
    http://localhost:8080/api
```

Send no header

```shell-session
$ curl -X POST \
    -H "Content-Type: application/json" \
    -d '{"operationName":null,"variables":{},"query":"{\n  coffees {\n    id\n    name\n    image\n    price\n    __typename\n  }\n}\n"}' \
    http://localhost:8080/api
```

Send and unsupported HTTP method

```shell-session
$ curl -X OPTIONS \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer 3d2c7d1d-a360-4cb2-b275-fc47acc8985d" \
    -d '{"operationName":null,"variables":{},"query":"{\n  coffees {\n    id\n    name\n    image\n    price\n    __typename\n  }\n}\n"}' \
    http://localhost:8080/api
```

## Add a coffee service to break apart the monolith

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service.yaml && \
    kubectl apply -f ../../workloads/hashicups/coffee-service/v1/deployment.yaml
```

## Manually test the coffee service with cURL

```shell-session
$ kubectl port-forward deploy/coffee-service 9090:9090
```

```shell-session
$ curl http://localhost:9090/coffees
```

## Add service router to siphon off coffee service traffic

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/service-router.yaml
```

## View in Consul

## View latency in Jaeger UI

## Add V2 DB instrumentation to coffee-service

Shout out to jmoiron/sqlx

## Deploy V2 Service

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/service-splitter.yaml
```

## Create service splitter entry for Canary rollout

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/service-splitter.yaml
```

## Create service resolver subset entry for Canary rollout

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/service-resolver.yaml
```

## Inspect the service splitter and service resolver CRDs

```shell-session
$ kubectl get servicesplitters
```

```shell-session
$ kubectl get serviceresolvers
```

## View network topology of services in Consul UI

## View traffic in Jeager UI to see how much traffic is routed to V2 and to inspect DB queries



## BONUS MATERIAL

## Deploy v3 with Waypoint (in memory DB version)

## Deploy service to multiple Cloud Providers by toggling Waypoint.hcl && kubeconfig

## Test each deployment

## SUPER BONUS MATERIAL

## Federate those different deployments with Primary DC

## Update service splitter to distribute evenly across different DCs or maybe failover and kill pod in primary?

## Show Jaeger Spans of distributed traces
