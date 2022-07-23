# Simple Network Diagram
![Simple Network Diagram](aws-demo.png)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_demo_1-fw"></a> [demo\_1-fw](#module\_demo\_1-fw) | ./modules/network_firewall/ | n/a |
| <a name="module_demo_1_endpoints"></a> [demo\_1\_endpoints](#module\_demo\_1\_endpoints) | ./modules/vpc/modules/endpoints/ | n/a |
| <a name="module_demo_1_private_sub_ram"></a> [demo\_1\_private\_sub\_ram](#module\_demo\_1\_private\_sub\_ram) | ./modules/vpc/modules/ram/ | n/a |
| <a name="module_demo_1_public_sub_ram"></a> [demo\_1\_public\_sub\_ram](#module\_demo\_1\_public\_sub\_ram) | ./modules/vpc/modules/ram/ | n/a |
| <a name="module_demo_1_vpc"></a> [demo\_1\_vpc](#module\_demo\_1\_vpc) | ./modules/vpc/ | n/a |
| <a name="module_demo_2-fw"></a> [demo\_2-fw](#module\_demo\_2-fw) | ./modules/network_firewall/ | n/a |
| <a name="module_demo_2_endpoints"></a> [demo\_2\_endpoints](#module\_demo\_2\_endpoints) | ./modules/vpc/modules/endpoints/ | n/a |
| <a name="module_demo_2_private_sub_ram"></a> [demo\_2\_private\_sub\_ram](#module\_demo\_2\_private\_sub\_ram) | ./modules/vpc/modules/ram/ | n/a |
| <a name="module_demo_2_public_sub_ram"></a> [demo\_2\_public\_sub\_ram](#module\_demo\_2\_public\_sub\_ram) | ./modules/vpc/modules/ram/ | n/a |
| <a name="module_demo_2_vpc"></a> [demo\_2\_vpc](#module\_demo\_2\_vpc) | ./modules/vpc/ | n/a |
| <a name="module_dxg-01"></a> [dxg-01](#module\_dxg-01) | ./modules/vpc/modules/dx_gateway/ | n/a |
| <a name="module_egress-fw"></a> [egress-fw](#module\_egress-fw) | ./modules/network_firewall/ | n/a |
| <a name="module_egress_vpc"></a> [egress\_vpc](#module\_egress\_vpc) | ./modules/vpc/ | n/a |
| <a name="module_inspection-fw"></a> [inspection-fw](#module\_inspection-fw) | ./modules/network_firewall/ | n/a |
| <a name="module_inspection_vpc"></a> [inspection\_vpc](#module\_inspection\_vpc) | ./modules/vpc/ | n/a |
| <a name="module_transit_gateway_usw2"></a> [transit\_gateway\_usw2](#module\_transit\_gateway\_usw2) | ./modules/vpc/modules/transit_gateway/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.default](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.dxg](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.egress](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.inspection](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_security_group.demo_1_sg](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/resources/security_group) | resource |
| [aws_security_group.demo_2_sg](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/resources/security_group) | resource |
| [aws_security_group.demo_1_default](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/data-sources/security_group) | data source |
| [aws_security_group.demo_2_default](https://registry.terraform.io/providers/hashicorp/aws/4.5.0/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | AWS Access Key | `string` | `null` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | AWS Role ID | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | AWS Role ARN to Assume | `string` | `null` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | AWS Secret Key | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_demo_1_private_sub_ram_arn"></a> [demo\_1\_private\_sub\_ram\_arn](#output\_demo\_1\_private\_sub\_ram\_arn) | RAM share ARNs of the demo\_1 private subnets |
| <a name="output_demo_1_public_sub_ram_arn"></a> [demo\_1\_public\_sub\_ram\_arn](#output\_demo\_1\_public\_sub\_ram\_arn) | RAM share ARNs of the demo\_1 public subnets |
| <a name="output_demo_1_vpc"></a> [demo\_1\_vpc](#output\_demo\_1\_vpc) | VPC Outputs |
| <a name="output_demo_1_vpc_id"></a> [demo\_1\_vpc\_id](#output\_demo\_1\_vpc\_id) | VPC ID |
| <a name="output_demo_2_private_sub_ram_arn"></a> [demo\_2\_private\_sub\_ram\_arn](#output\_demo\_2\_private\_sub\_ram\_arn) | RAM share ARNs of the demo\_2 private subnets |
| <a name="output_demo_2_public_sub_ram_arn"></a> [demo\_2\_public\_sub\_ram\_arn](#output\_demo\_2\_public\_sub\_ram\_arn) | RAM share ARNs of the demo\_2 public subnets |
| <a name="output_demo_2_vpc"></a> [demo\_2\_vpc](#output\_demo\_2\_vpc) | VPC Outputs |
| <a name="output_demo_2_vpc_id"></a> [demo\_2\_vpc\_id](#output\_demo\_2\_vpc\_id) | VPC ID |
| <a name="output_inspection_firewall_subnets"></a> [inspection\_firewall\_subnets](#output\_inspection\_firewall\_subnets) | IDs of the firewall subnetss from the inspection VPC |
| <a name="output_tgw_resource_ids"></a> [tgw\_resource\_ids](#output\_tgw\_resource\_ids) | ID of the TGW resources |
<!-- END_TF_DOCS -->