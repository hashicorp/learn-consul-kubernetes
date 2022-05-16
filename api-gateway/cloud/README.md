# Consul API Gateway on EKS + HCP

## Overview

Terraform will perform the following actions:
- Create VPC and HVN networks
- Peer VPC and HVN networks
- Create HCP Consul cluster
- Create EKS cluster
- Deploy API GW CRDs to EKS
- Deploy Consul + API GW controller to EKS

You will perform these steps:
- Deploy Hashicups & Echo services to EKS
- Deploy remaining API GW resources (gateway.yaml & routes.yaml) to EKS
- Verify AWS Load Balancer is created once API GW is deployed
- Verify access behavior with Hashicups via API GW
- Verify load balancing behavior with Echo Servers via API GW
- Clean up environment

## Steps

1. Clone repo
2. `cd api-gateway/`
3. Set credential environment variables for AWS and HCP
 1. `export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY"`
    `export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_KEY"`
    `export HCP_CLIENT_ID="YOUR_HCP_CLIENT_ID"`
    `export HCP_CLIENT_SECRET="YOUR_HCP_SECRET"`
4. Run Terraform (resource creation will take 10-15 minutes to complete)
    1. `terraform -chdir=terraform/ init`
    2. `terraform -chdir=terraform/ apply`
5. `kubectl apply --filename two-services/`
6. `kubectl apply --filename api-gw/consul-api-gateway.yaml && kubectl wait --for=condition=ready gateway/api-gateway --timeout=90s && kubectl apply --filename api-gw/routes.yaml` 
7. Locate the external IP for your API Gateway
   1. `kubectl get services`
8.  Visit the following urls in the browser
    1.  [http://[your-aws-load-balancer-dns-name]/hashicups](http://[your-aws-load-balancer-dns-name]/hashicups)
    2.  [http://[your-aws-load-balancer-dns-name]/echo](http://[your-aws-load-balancer-dns-name]/echo)
9.  Clean up
    1. Remove patch finalizers on the API gateway
       1. ```shell
          kubectl patch gatewayclasses.gateway.networking.k8s.io consul-api-gateway --type merge --patch '{"metadata":{"finalizers":[]}}'
          ```
       2. ```shell
          kubectl patch gatewayclassconfigs.api-gateway.consul.hashicorp.com consul-api-gateway --type merge --patch '{"metadata":{"finalizers":[]}}'
          ```
    2. Destroy Terraform resources
      `terraform -chdir=terraform/ destroy`