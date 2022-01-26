# Consul Enterprise Admin Partitions EKS

This example code is for the Learn tutorial [Multi Cluster Applications with Consul Enterprise Admin Partitions](https://learn.hashicorp.com/tutorials/consul/kubernetes-admin-partitions?in=consul/kubernetes). Please visit the tutorial for an in-depth explanation.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.66.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.66.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_create_peering_secondary_to_primary"></a> [create\_peering\_secondary\_to\_primary](#module\_create\_peering\_secondary\_to\_primary) | ./peering | n/a |
| <a name="module_install_consul_enterprise_client"></a> [install\_consul\_enterprise\_client](#module\_install\_consul\_enterprise\_client) | ./consul_enterprise | n/a |
| <a name="module_install_consul_enterprise_server"></a> [install\_consul\_enterprise\_server](#module\_install\_consul\_enterprise\_server) | ./consul_enterprise | n/a |
| <a name="module_post_vpc_creation_routing_rules_primary_to_secondary"></a> [post\_vpc\_creation\_routing\_rules\_primary\_to\_secondary](#module\_post\_vpc\_creation\_routing\_rules\_primary\_to\_secondary) | ./post_routing | n/a |
| <a name="module_post_vpc_creation_routing_rules_secondary_to_primary"></a> [post\_vpc\_creation\_routing\_rules\_secondary\_to\_primary](#module\_post\_vpc\_creation\_routing\_rules\_secondary\_to\_primary) | ./post_routing | n/a |
| <a name="module_primary_kubernetes"></a> [primary\_kubernetes](#module\_primary\_kubernetes) | ./k8s | n/a |
| <a name="module_secondary_kubernetes"></a> [secondary\_kubernetes](#module\_secondary\_kubernetes) | ./k8s | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The AZs in which the Clusters will deploy | `map` | <pre>{<br>  "zone_one": "us-east-1a",<br>  "zone_two": "us-east-1f"<br>}</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to pass to AWS. You can set them here, or in a tfvars file. | `map(string)` | <pre>{<br>  "github": "hashicorp/learn-consul-kubernetes"<br>}</pre> | no |
| <a name="input_deploy_type"></a> [deploy\_type](#input\_deploy\_type) | The name of the Consul Enterprise installation types. If this comment is here please don't change these values. The configs are currently reliant on these namse which will be addressed at a later time. | `map` | <pre>{<br>  "client": "client",<br>  "server": "server"<br>}</pre> | no |
| <a name="input_eks_cluster_name_primary"></a> [eks\_cluster\_name\_primary](#input\_eks\_cluster\_name\_primary) | Name of the primary EKS Cluster that runs the Consul Enterprise server cluster | `string` | `"primary"` | no |
| <a name="input_eks_cluster_name_secondary"></a> [eks\_cluster\_name\_secondary](#input\_eks\_cluster\_name\_secondary) | Name of the secondary EKS Cluster that runs the Consul Enterprise client cluster | `string` | `"secondary"` | no |
| <a name="input_eks_cluster_primary_ips_consul_server"></a> [eks\_cluster\_primary\_ips\_consul\_server](#input\_eks\_cluster\_primary\_ips\_consul\_server) | The CIDR groups for the Primary Cluster's IP addresses | `map` | <pre>{<br>  "internet": "0.0.0.0/0",<br>  "private": "10.100.1.0/24",<br>  "public": "10.100.2.0/24",<br>  "vpc": "10.100.0.0/16"<br>}</pre> | no |
| <a name="input_eks_cluster_secondary_ips_consul_client"></a> [eks\_cluster\_secondary\_ips\_consul\_client](#input\_eks\_cluster\_secondary\_ips\_consul\_client) | The CIDR groups for the Secondary Cluster's IP addresses | `map` | <pre>{<br>  "internet": "0.0.0.0/0",<br>  "private": "172.30.1.0/24",<br>  "public": "172.30.2.0/24",<br>  "vpc": "172.30.0.0/16"<br>}</pre> | no |
| <a name="input_license_name"></a> [license\_name](#input\_license\_name) | The name of the Consul Enterprise license file. Place this file in the `./consul_enterprise/` directory | `string` | `"consul.hclic"` | no |

## Outputs

No outputs.
