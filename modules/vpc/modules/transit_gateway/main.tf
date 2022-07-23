locals {
  route_table_set_map = { for i in var.route_table_sets : i.rt_association => i... }
}

#####
# Create Transit Gateway
#####

resource "aws_ec2_transit_gateway" "this" {
  description                     = "${var.region} tgw"
  amazon_side_asn                 = var.tgw_asn
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  dns_support                     = var.dns_support

  tags = merge(
    { Name = "${var.tgw_name}" },
    var.tags,
    var.tgw_tags,
  )
}

module "tgw_attachments" {
  for_each = local.route_table_set_map
  # for_each = var.tgw_resources
  source = "./modules/transit_gateway_resources"
  # version            = "~> 0.0.16"
  region             = var.region
  rt_name            = each.key
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  rt_details         = each.value
  tags = merge(
    var.tags,
    var.tgw_tags,
  )
}
