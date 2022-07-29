# Consul-terraform-sync on EKS + HCP

## Overview

Terraform will perform the following actions:
- Create EKS cluster in a VPC
- Create EC2 instance in a VPC

You will perform the following actions:
- Deploy Consul to the EKS cluster
- Configure EKS to forward requests to Consul for `.consul` TLD
- Join the Consul client agent on the EC2 instance to the Consul cluster in EKS

## Steps

1. Set credential environment variables for AWS and HCP
    1. 
    ```shell
    export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY"
    export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_KEY"
    ```
2. Run Terraform (resource creation will take 10-15 minutes to complete)
    1. `terraform -chdir=infrastructure/ init`
    2. `terraform -chdir=infrastructure/ apply`
3. Configure kubectl to communicate with your EKS cluster
    1. `aws eks --region $(terraform -chdir=infrastructure/ output -raw vpc_region) update-kubeconfig --name $(terraform -chdir=infrastructure/ output -raw kubernetes_cluster_id)`
4. Deploy Consul to your EKS cluster
    1. `consul-k8s install -config-file helm/consul-values.yaml`
5. Configure Kubernetes to forward `.consul` TLD requests to Consul
    1. `kubectl -n kube-system get configmap coredns -o YAML | sed "s/^    }/    }\\n    consul {\\n      errors\\n      cache 30\\n      forward . $(kubectl -n consul get svc consul-dns --output jsonpath='{.spec.clusterIP}')\\n    }/" | kubectl apply -f -`
    2. `kubectl rollout restart -n kube-system deployment/coredns`
6. Create EC2 instance
    1. `echo "aws_region=\"$(terraform -chdir=infrastructure/ output -raw region)\"\nvpc_id=\"$(terraform -chdir=infrastructure/ output -raw vpc_id)\"\nvpc_cidr_block=\"$(terraform -chdir=infrastructure/ output -raw vpc_cidr_block)\"\nsubnet_id=\"$(terraform -chdir=infrastructure/ output -raw vpc_public_subnets)\"\ncluster_id=\"$(terraform -chdir=infrastructure/ output -raw kubernetes_cluster_id)\"\nvpc_security_group_id=\"$(terraform -chdir=infrastructure/ output -raw vpc_security_group_id)\"\n" > ./ec2-instance-cts/terraform.tfvars`
    2. `terraform -chdir=ec2-instance-cts init`
    3. `terraform -chdir=ec2-instance-cts apply`
7. Wait for Consul service to deploy and become active, then join it to the K8s Consul cluster
    1. `ssh ubuntu@$(terraform -chdir=ec2-instance-cts output -raw ec2_client) -i ./ec2-instance-cts/consul-client.pem "systemctl status consul`
    2. `ssh ubuntu@$(terraform -chdir=ec2-instance-cts output -raw ec2_client) -i ./ec2-instance-cts/consul-client.pem "consul join $(kubectl -n consul get pods -l component=server,app=consul -ojson | jq -r '.items[0].status.hostIP')"`
    3. `ssh ubuntu@$(terraform -chdir=ec2-instance-cts output -raw ec2_client) -i ./ec2-instance-cts/consul-client.pem "consul members"`
8. Clean up
    1. `terraform -chdir=ec2-instance-cts/ destroy`
    2. `terraform -chdir=infrastructure/ destroy`

## Thank you

This work has reused content from the following repositories:

- [Provision an EKS Cluster (AWS)](https://github.com/hashicorp/learn-terraform-provision-eks-cluster)
- [Provision an HCP Cluster for EC2 instances (AWS)](https://github.com/hashicorp/learn-consul-terraform/tree/main/datacenter-deploy-ec2-hcp)
