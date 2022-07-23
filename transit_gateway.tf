#####
# Create tgw
#####

module "transit_gateway_usw2" {
  source = "./modules/vpc/modules/transit_gateway/"
  # version                        = "~> 0.0.16"
  tgw_name                       = "${local.region_shorthand}-tgw-01"
  region                         = var.region
  auto_accept_shared_attachments = "enable"
  tgw_asn                        = "65512"
  # tags                           = local.default_tags

  route_table_sets = [
    {
      name           = "demo_1"
      vpc_id         = module.demo_1_vpc.vpc_id
      subnet_ids     = module.demo_1_vpc.tgw_subnets
      rt_association = "default"
      appliance_mode = "disable"
      }, {
      name           = "demo_2"
      vpc_id         = module.demo_2_vpc.vpc_id
      subnet_ids     = module.demo_2_vpc.tgw_subnets
      rt_association = "default"
      appliance_mode = "disable"
      }, {
      name           = "inspection"
      vpc_id         = module.inspection_vpc.vpc_id
      subnet_ids     = module.inspection_vpc.tgw_subnets
      rt_association = "inspection"
      appliance_mode = "enable"
      }, {
      name           = "egress"
      vpc_id         = module.egress_vpc.vpc_id
      subnet_ids     = module.egress_vpc.tgw_subnets
      rt_association = "egress"
      appliance_mode = "enable"
    }
  ]
}



#####
# Add routes to TGW RTBs
#####

resource "aws_ec2_transit_gateway_route" "default" {
  for_each = { for k, v in local.default_tgw_routes : k => v
  if v != null }

  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.tgw_attachment_id
  transit_gateway_route_table_id = module.transit_gateway_usw2.tgw_resource_ids.default.tgw_rtb_id
}
resource "aws_ec2_transit_gateway_route" "inspection" {
  for_each = { for k, v in local.inspection_tgw_routes : k => v
  if v != null }

  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.tgw_attachment_id
  transit_gateway_route_table_id = module.transit_gateway_usw2.tgw_resource_ids.inspection.tgw_rtb_id
}

resource "aws_ec2_transit_gateway_route" "egress" {
  for_each = { for k, v in local.egress_tgw_routes : k => v
  if v != null }

  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.tgw_attachment_id
  transit_gateway_route_table_id = module.transit_gateway_usw2.tgw_resource_ids.egress.tgw_rtb_id
}
