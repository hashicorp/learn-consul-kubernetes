## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.66.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_create_peering_starfleet_to_ufp"></a> [create\_peering\_starfleet\_to\_ufp](#module\_create\_peering\_starfleet\_to\_ufp) | ./peering | n/a |
| <a name="module_install_consul_enterprise"></a> [install\_consul\_enterprise](#module\_install\_consul\_enterprise) | ./consul_enterprise | n/a |
| <a name="module_install_consul_enterprise_secondary"></a> [install\_consul\_enterprise\_secondary](#module\_install\_consul\_enterprise\_secondary) | ./consul_enterprise | n/a |
| <a name="module_post_route_starfleet_to_ufp"></a> [post\_route\_starfleet\_to\_ufp](#module\_post\_route\_starfleet\_to\_ufp) | ./post_routing | n/a |
| <a name="module_post_route_ufp_to_starfleet"></a> [post\_route\_ufp\_to\_starfleet](#module\_post\_route\_ufp\_to\_starfleet) | ./post_routing | n/a |
| <a name="module_starfleet_k8s"></a> [starfleet\_k8s](#module\_starfleet\_k8s) | ./k8s | n/a |
| <a name="module_ufp_k8s"></a> [ufp\_k8s](#module\_ufp\_k8s) | ./k8s | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_author"></a> [author](#input\_author) | n/a | `any` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | <pre>{<br>  "Team": "education",<br>  "deployedBy": "webdog"<br>}</pre> | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_eks_cluster_name_1"></a> [eks\_cluster\_name\_1](#input\_eks\_cluster\_name\_1) | n/a | `any` | n/a | yes |
| <a name="input_eks_cluster_name_2"></a> [eks\_cluster\_name\_2](#input\_eks\_cluster\_name\_2) | n/a | `any` | n/a | yes |
| <a name="input_eks_cluster_primary_ips_ufp"></a> [eks\_cluster\_primary\_ips\_ufp](#input\_eks\_cluster\_primary\_ips\_ufp) | n/a | `any` | n/a | yes |
| <a name="input_eks_cluster_secondary_ips_starfleet"></a> [eks\_cluster\_secondary\_ips\_starfleet](#input\_eks\_cluster\_secondary\_ips\_starfleet) | n/a | `any` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
