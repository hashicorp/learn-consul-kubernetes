## Quick Start (Mac)

This setup assumes using [Homebrew](https://brew.sh/) as a package manager and the [official HashiCorp tap](https://github.com/hashicorp/homebrew-tap). Consul will be installed in a Kubernetes cluster using the Helm chart, but the standalone binary is currently used for bootstrapping ACLs.

```bash
brew tap hashicorp/tap
brew cask install docker
brew install go jq kubectl kustomize kind helm hashicorp/tap/consul
```

Ensure Docker for Mac is running (enabling the Kubernetes single-node cluster is not necessary, as `kind` will build its own cluster), clone this repo, navigate to the root directory, then run:

```bash
./dev/run
```

In a new terminal tab, deploy the Hashicups and Echo applications:

```bash
kubectl apply -f dev/config/hashicups/two-services/
```

Check the pods to make sure they are up and running
```bash
kubectl get pods
```

Now deploy the API Gateway controller:

```bash
kubectl apply -f dev/config/hashicups/api-gw/
```

Check out the Consul UI at [https://localhost](https://localhost). Ignore the certificate error for now and click to proceed. Notice that the API Gateway `test-gateway` has one merged upstream that you defined in the `consul-api-gateway.yaml` file as `HTTPRoute` definitions. In this example, it contains the `frontend` service and `echo` service.

If properly discovered, the Hashicups and Echo services will appear as intentions here:
[https://localhost/ui/dc1/services/test-gateway/intentions](https://localhost/ui/dc1/services/test-gateway/intentions)

Check out the Hashicups frontend UI at [https://localhost:8443/hashicups](https://localhost:8443/hashicups) to see that the API Gateway is successfully routing traffic into the service mesh.

Check out the Echo frontend UI at [https://localhost:8443/echo](https://localhost:8443/echo) to see that the API Gateway is successfully routing traffic into the service mesh.

You are now accessing two unique service mesh services via the API Gateway Controller.

Clean up the environment you just created:

```bash
kubectl delete -f dev/config/hashicups/two-services/
kubectl delete -f dev/config/hashicups/api-gw/
```
