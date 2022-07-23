<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tgw_attachments"></a> [tgw\_attachments](#module\_tgw\_attachments) | ./modules/transit_gateway_resources | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_accept_shared_attachments"></a> [auto\_accept\_shared\_attachments](#input\_auto\_accept\_shared\_attachments) | Automatically accept attachments to the TGW | `string` | `"disable"` | no |
| <a name="input_dns_support"></a> [dns\_support](#input\_dns\_support) | Enable DNS resolution of AWS internal names over Transit Gateway | `string` | `"enable"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region tgw should reside in | `string` | n/a | yes |
| <a name="input_route_table_sets"></a> [route\_table\_sets](#input\_route\_table\_sets) | A list of VPCs to build transit gatways resources for as well as what route table set they should belong to. rt\_association should be the name of the route table to assciate to, if the route table specified doesn't exist it will be created. | <pre>list(object({<br>    name           = string<br>    vpc_id         = string<br>    subnet_ids     = list(string)<br>    rt_association = string<br>    appliance_mode = string<br>    # attachment_tags = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to assign to the TGW and it's attachments | `map(string)` | `{}` | no |
| <a name="input_tgw_asn"></a> [tgw\_asn](#input\_tgw\_asn) | (Optional) Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is `64512` to `65534` for 16-bit ASNs and `4200000000` to `4294967294` for 32-bit ASNs. Default value: `64512`. | `string` | `null` | no |
| <a name="input_tgw_name"></a> [tgw\_name](#input\_tgw\_name) | Name of the TGW resource | `string` | n/a | yes |
| <a name="input_tgw_tags"></a> [tgw\_tags](#input\_tgw\_tags) | Tags to assign to the TGW and it's attachments. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tgw_id"></a> [tgw\_id](#output\_tgw\_id) | ID of the TGW |
| <a name="output_tgw_resource_ids"></a> [tgw\_resource\_ids](#output\_tgw\_resource\_ids) | IDs of transite gateway attachments, route tables, and associations for each route table set |
<!-- END_TF_DOCS -->