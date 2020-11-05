# Managing Consul Config Entries as Kubernetes CRDs

All commands in this file assume that you have cloned this repository and are
issuing the commands from the directory that contains this README file. If you
are in a differerent directory, you will have to adjust your paths accordingly.


## Create a test cluster

```shell-session
$ kind create cluster --name crds
```

## Install Consul on Kubernetes using the official Helm chart

```shell-session
$ helm install -f ./config.yaml consul hashicorp/consul  --version "0.25.0" --wait
```

## Install the Jaeger using the Jaeger Operator

```shell-session
$ helm install jaeger jaegertracing/jaeger-operator --version "2.17.0" --wait
```

## Register Jaeger CRD - TODO Validate this is required

```shell-session
$ kubectl apply -f ../../content/layer7-observability/jaeger/jaeger.yaml
```

## Enable Jaeger tracing by registering a ProxyDefaults config entry

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/proxy-defaults.yaml
```

## Deploy V1 of the workload

```shell-session
$ kubectl apply -f ./hashicups
```

## Expose the Consul UI

```shell-session
$ kubectl port-forward consul-server-0 8500:8500
```

## Expose the Jaeger UI

```shell-session
$ kubectl port-forward deploy/jaeger 16686:16686
```

## Generate traffic

```shell-session
$ kubectl apply -f ../../content/layer7-observability/traffic.yaml
```

## View traffic in Consul

## View tracing in Jaeger

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
$ curl -X POST -H "Authorization: bearer 3d2c7d1d-a360-4cb2-b275-fc47acc8985d" http://localhost:8080/api -d
```

Send the wrong header

```shell-session
$ curl -X POST -H "api-token: 3d2c7d1d-a360-4cb2-b275-fc47acc8985d" http://localhost:8080/api -d
```

Send no header

```shell-session
$ curl -X POST http://localhost:8080/api -d
```

Send and unsupported HTTP method

```shell-session
$ curl -X OPTIONS -H "Authorization: bearer 3d2c7d1d-a360-4cb2-b275-fc47acc8985d" http://localhost:8080/api -d
```

## Deploy canary release of public and product APIs

```shell-session
$ kubectl apply -f ./canary
```

## Create service resolver subset entry for Canary

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/service-resolver.yaml
```

## Test manually using service router

```shell-session
$ kubectl apply -f ../../content/custom-resource-definitions/service-router.yaml
```



###


```shell-session
$ kubectl apply -f ../../workloads/hashicups/jaeger
```

