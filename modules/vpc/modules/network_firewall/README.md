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
| [aws_networkfirewall_firewall.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_rule_group.domain_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.fivetuple_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.stateless_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_stateful_rule_group"></a> [domain\_stateful\_rule\_group](#input\_domain\_stateful\_rule\_group) | Config for domain type stateful rule group. | `list(any)` | `[]` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Firewall Name | `string` | `null` | no |
| <a name="input_fivetuple_stateful_rule_group"></a> [fivetuple\_stateful\_rule\_group](#input\_fivetuple\_stateful\_rule\_group) | Config for 5-tuple type stateful rule group. | <pre>list(object({<br>    capacity    = number<br>    name        = string<br>    description = string<br>    rule_config = list(object({<br>      protocol              = string<br>      source_ipaddress      = string<br>      source_port           = any<br>      destination_ipaddress = string<br>      destination_port      = any<br>      direction             = string<br>      actions = object({<br>        type = string<br>      })<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | `null` | no |
| <a name="input_stateful_default_actions"></a> [stateful\_default\_actions](#input\_stateful\_default\_actions) | Default stateful Action. | `string` | `"drop_strict"` | no |
| <a name="input_stateful_rule_order"></a> [stateful\_rule\_order](#input\_stateful\_rule\_order) | Stateful rule order. | `string` | `"STRICT_ORDER"` | no |
| <a name="input_stateless_default_actions"></a> [stateless\_default\_actions](#input\_stateless\_default\_actions) | Default stateless Action. | `string` | `"drop"` | no |
| <a name="input_stateless_fragment_default_actions"></a> [stateless\_fragment\_default\_actions](#input\_stateless\_fragment\_default\_actions) | Default Stateless action for fragmented packets | `string` | `"drop"` | no |
| <a name="input_stateless_rule_group"></a> [stateless\_rule\_group](#input\_stateless\_rule\_group) | Config for stateless rule group. | `list(any)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Region | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to assign to ANF and all of it's endpoints | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID of the VPC in which to create the firewall. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_attachment_ids"></a> [firewall\_attachment\_ids](#output\_firewall\_attachment\_ids) | A list of firewall attachment IDs |
<!-- END_TF_DOCS -->