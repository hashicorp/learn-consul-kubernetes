## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.74.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | 0.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws"></a> [aws](#module\_aws) | ./modules/aws | n/a |
| <a name="module_aws_vpc"></a> [aws\_vpc](#module\_aws\_vpc) | registry.terraform.io/terraform-aws-modules/vpc/aws | 3.11.5 |
| <a name="module_cleanup"></a> [cleanup](#module\_cleanup) | ./modules/cleanup | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | registry.terraform.io/terraform-aws-modules/eks/aws | 18.9.0 |
| <a name="module_eks_iam"></a> [eks\_iam](#module\_eks\_iam) | ./modules/iam | n/a |
| <a name="module_hcp_applications"></a> [hcp\_applications](#module\_hcp\_applications) | ./modules/hcp_applications | n/a |
| <a name="module_hcp_networking"></a> [hcp\_networking](#module\_hcp\_networking) | ./modules/hcp_networking | n/a |
| <a name="module_hcp_networking_primitives"></a> [hcp\_networking\_primitives](#module\_hcp\_networking\_primitives) | ./modules/hcp_networking_primitives | n/a |
| <a name="module_iam_role_for_service_accounts"></a> [iam\_role\_for\_service\_accounts](#module\_iam\_role\_for\_service\_accounts) | registry.terraform.io/terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 4.14.0 |

## Resources

| Name | Type |
|------|------|
| [local_file.kubernetes_tfvars](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.update_kubeconfig](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability Zones for the EKS Cluster deployed in main.tf | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b",<br>  "us-east-1c"<br>]</pre> | no |
| <a name="input_aws_cidr_block"></a> [aws\_cidr\_block](#input\_aws\_cidr\_block) | CIDR block for AWS VPC | `map` | <pre>{<br>  "allocation": "172.16.0.0/19",<br>  "subnets": {<br>    "private": [<br>      "172.16.2.0/24",<br>      "172.16.3.0/24"<br>    ],<br>    "public": [<br>      "172.16.4.0/24",<br>      "172.16.5.0/24"<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | HCP Default Cloud Provider | `string` | `"aws"` | no |
| <a name="input_cluster_and_vpc_info"></a> [cluster\_and\_vpc\_info](#input\_cluster\_and\_vpc\_info) | EKS Cluster Configuration Details | `any` | <pre>{<br>  "name": "tutorialCluster",<br>  "policy_description": "Grant the cluster access to describe itself and assume an IAM Role.",<br>  "policy_name": "workingenvironmentpolicy",<br>  "region": "us-east-1",<br>  "stage": "dev",<br>  "vpc_name": "hcpTutorialAwsVpc"<br>}</pre> | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to pass to AWS resources | `map(string)` | <pre>{<br>  "github": "hashicorp/learn-consul-kubernetes"<br>}</pre> | no |
| <a name="input_hcp_consul_datacenter_name"></a> [hcp\_consul\_datacenter\_name](#input\_hcp\_consul\_datacenter\_name) | Name of Consul datacenter | `string` | `"dc1"` | no |
| <a name="input_hcp_hvn_config"></a> [hcp\_hvn\_config](#input\_hcp\_hvn\_config) | CIDR block for HCP HVN | `map` | <pre>{<br>  "allocation": "10.100.0.0/19",<br>  "consul_tier": "standard",<br>  "name": "hcpTutorial",<br>  "vault_tier": "starter_small"<br>}</pre> | no |
| <a name="input_hcp_peering_identifier"></a> [hcp\_peering\_identifier](#input\_hcp\_peering\_identifier) | Name of the peering connection as displayed in the AWS API and Management Console | `string` | `"hcp-consul-vault-tutorial"` | no |
| <a name="input_hcp_region"></a> [hcp\_region](#input\_hcp\_region) | HCP region for HCP-created resources | `string` | `"us-east-1"` | no |
| <a name="input_hcp_vault_cluster_name"></a> [hcp\_vault\_cluster\_name](#input\_hcp\_vault\_cluster\_name) | name of HCP Vault cluster | `string` | `"vault-cluster"` | no |
| <a name="input_hcp_vault_default_namespace"></a> [hcp\_vault\_default\_namespace](#input\_hcp\_vault\_default\_namespace) | HCP Vault's Default Namespace. Must be specified when running Vault Enterprise | `string` | `"admin"` | no |
| <a name="input_kube_namespace"></a> [kube\_namespace](#input\_kube\_namespace) | Which kubernetes namespace to use in this tutorial | `string` | `"default"` | no |
| <a name="input_kube_service_account_name"></a> [kube\_service\_account\_name](#input\_kube\_service\_account\_name) | Name of the Kubernetes service account that maps to an IAM Role | `string` | `"tutorial"` | no |
| <a name="input_node_group_configuration"></a> [node\_group\_configuration](#input\_node\_group\_configuration) | Settings for the EKS Node Groups to pass to the EKS Module in main.tf | `any` | <pre>{<br>  "ami_type": "AL2_x86_64",<br>  "desired_instances": 2,<br>  "disk_size_gigs": 50,<br>  "instance_types": [<br>    "m5.large"<br>  ],<br>  "max_instances": 2,<br>  "min_instances": 2<br>}</pre> | no |
| <a name="input_profile_name"></a> [profile\_name](#input\_profile\_name) | Profile Name for the AWS Credentials in the working environment pod | `string` | `"kubeUser"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region in which to run this terraform code for the AWS Provider | `string` | `"us-east-1"` | no |
| <a name="input_run_cleanup"></a> [run\_cleanup](#input\_run\_cleanup) | Whether or not to run the cleanup script. False by default, set to True in the tutorial content as environment variable | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consul_auth_data"></a> [consul\_auth\_data](#output\_consul\_auth\_data) | Authentication data for Consul that is passed to the working environment |
| <a name="output_eks_data"></a> [eks\_data](#output\_eks\_data) | Data for the EKS Cluster that is sent to the working environment |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The OIDC Provider ARN. Used to connect AWS IAM Roles to Service Accounts whose identities are managed by the Kubernetes cluster. Used to allow the reader to access the AWS CLI in the Pod without copying credentials over. |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | The Service Account Role ARN created for the EKS Cluster. This is passed to the working environment as a Service Annotation in the deployment's podspec. |
| <a name="output_vault_auth_data"></a> [vault\_auth\_data](#output\_vault\_auth\_data) | Authentication data for Vault that is passed to the working environment |
