module "dxg-01" {
  count  = local.only_in_production
  source = "./modules/vpc/modules/dx_gateway/"
  # version = "~> 0.0.87"

  dxg_name = "${var.region}-dxg-01"
  tags     = local.default_tags
  region   = var.region
  tgw_id   = module.transit_gateway_usw2.tgw_id
  dxg_asn  = "65521"
  allowed_prefixes = [
    "10.100.0.0/24", # inspection
    "10.100.1.0/24", # egress
    "10.105.0.0/16", # demo_1
    "10.106.0.0/16", # demo_2
  ]

  vif = {
    "Demo-DX-01" = {
      name          = "usw2-vif-01"
      connection_id = "dxcon-fg4b1joq"
      vlan          = 100
      bgp_asn       = 64605
      bgp_auth_key  = "ChangeMe"
    }
  }
}

# Add routes to RT
resource "aws_ec2_transit_gateway_route" "dxg" {
  for_each = { for k, v in local.dxg_tgw_routes : k => v
  if v != null }

  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.tgw_attachment_id
  transit_gateway_route_table_id = module.dxg-01[0].tgw_rtb_id
}
