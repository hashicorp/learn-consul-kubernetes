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
$ kubectl apply -f ../../workloads/hashicups/coffee-service/proxy-defaults.yaml
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
$ kubectl port-forward svc/consul-ui 8080:80
```

## Generate traffic

```shell-session
$ kubectl apply -f ../../content/layer7-observability/traffic.yaml
```

## View traffic in Consul

STALL - Takes time to collect metrics

## Add a coffee service to break apart the monolith

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service.yaml && \
    kubectl apply -f ../../workloads/hashicups/coffee-service/v1/deployment.yaml
```

## View the Coffee Service in the UI

View Protocol? & Meta.version

## Manually test the coffee service with cURL

```shell-session
$ kubectl port-forward deploy/coffee-service 9090:9090
```

```shell-session
$ curl http://localhost:9090/coffees
```

## Add service router to siphon off coffee service traffic

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service-router.yaml
```

## View Product API routing in Consul

STALL - It's going to take a while to re-route traffic

```shell-session
$ kubectl logs deploy/product-api product-api -f
```

```shell-session
$ kubectl logs deploy/coffee-service coffee-service -f
```

## Create service resolver & splitter entry for Canary rollout

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service-resolver.yaml
```

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service-splitter.yaml
```

## Inspect the service splitter and service resolver CRDs

```shell-session
$ kubectl get servicesplitters
```

```shell-session
$ kubectl describe servicesplitter coffee-service
````

```shell-session
$ kubectl get serviceresolvers
```

```shell-session
$ kubectl describe serviceresolver coffee-service
```

## Deploy V2 Service

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/v2/deployment.yaml
```

```shell-session
$ kubectl logs deploy/coffee-service-v2 coffee-service -f
```

## View coffee-service routing in Consul UI

## View network topology of services in Consul UI

## Update the Split to 50/50

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service-splitter.yaml
```

## View routing percentages in the Consul UI

## Update the Split to 0/100

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service-splitter.yaml
```

## Delete the V1 Service

```shell-service
$ kubectl delete -f ../../workloads/hashicups/coffee-service/v1/deployment.yaml
```

## Delete v1 from the Splitter and Resolver

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service-splitter.yaml
```

```shell-session
$ kubectl apply -f ../../workloads/hashicups/coffee-service/service-resolver.yaml
```


## BONUS MATERIAL

## Deploy v3 with Waypoint (in memory DB version)

## Deploy service to multiple Cloud Providers by toggling Waypoint.hcl && kubeconfig

## Test each deployment

## SUPER BONUS MATERIAL

## Federate those different deployments with Primary DC

## Update service splitter to distribute evenly across different DCs or maybe failover and kill pod in primary?

## Show Jaeger Spans of distributed traces
