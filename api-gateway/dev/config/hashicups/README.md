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

In a new terminal tab, deploy the API Gateway controller and Hashicups:

```bash
kubectl apply -f dev/config/hashicups/two-services
```

Check the pods to make sure they are up and running
```bash
kubectl get pods
```

Check out the Consul UI at [https://localhost]. Ignore the certificate error for now and click to proceed. Notice that the API Gateway `test-gateway` has one upstream that you defined in the `consul-api-gateway.yaml` file as an `HTTPRoute`. In this example, it contains the `frontend` service and `echo` service.

Check out the Hashicups frontend UI at [https://localhost:8443/hashicups] to see that the API Gateway is successfully routing traffic into the service mesh.

Check out the Echo frontend UI at [https://localhost:8443/echo] to see that the API Gateway is successfully routing traffic into the service mesh.

Clean up the environment you just created:

```bash
kubectl delete -f dev/config/hashicups/two-services
```
