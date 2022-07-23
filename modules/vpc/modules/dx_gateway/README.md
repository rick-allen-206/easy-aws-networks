<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dx_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway) | resource |
| [aws_dx_gateway_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway_association) | resource |
| [aws_dx_transit_virtual_interface.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_transit_virtual_interface) | resource |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_dx_gateway_attachment.dxg_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_dx_gateway_attachment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_prefixes"></a> [allowed\_prefixes](#input\_allowed\_prefixes) | (Optional) VPC prefixes (CIDRs) to advertise to the Direct Connect gateway. Defaults to the CIDR block of the VPC associated with the Virtual Gateway. To enable drift detection, must be configured. | `list(string)` | `[]` | no |
| <a name="input_dxg_asn"></a> [dxg\_asn](#input\_dxg\_asn) | (Required) The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration. | `string` | `null` | no |
| <a name="input_dxg_name"></a> [dxg\_name](#input\_dxg\_name) | The name of the DXG | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | region tgw should reside in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to apply to dxg and all of it's resources | `map(string)` | `{}` | no |
| <a name="input_tgw_id"></a> [tgw\_id](#input\_tgw\_id) | (Optional) The ID of the VGW or transit gateway with which to associate the Direct Connect gateway. Used for single account Direct Connect gateway associations. | `string` | `null` | no |
| <a name="input_vif"></a> [vif](#input\_vif) | (Required) Virtual interface information. | <pre>map(object({<br>    connection_id = string<br>    name          = string<br>    vlan          = number<br>    bgp_asn       = number<br>    bgp_auth_key  = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dxg_assoc_association_id"></a> [dxg\_assoc\_association\_id](#output\_dxg\_assoc\_association\_id) | The ID of the Direct Connect gateway association. |
| <a name="output_dxg_assoc_resource_id"></a> [dxg\_assoc\_resource\_id](#output\_dxg\_assoc\_resource\_id) | The ID of the Direct Connect gateway association resource. |
| <a name="output_dxg_attch_id"></a> [dxg\_attch\_id](#output\_dxg\_attch\_id) | ID of the Transit Gateway attachment to the Direct Connect Gateway |
| <a name="output_dxg_id"></a> [dxg\_id](#output\_dxg\_id) | The ID of the gateway. |
| <a name="output_tgw_rtb_id"></a> [tgw\_rtb\_id](#output\_tgw\_rtb\_id) | ID of the Transit Gateway route table |
<!-- END_TF_DOCS -->