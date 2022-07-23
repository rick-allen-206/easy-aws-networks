# TODO: Fix routing
# TODO: Move routes to YAML file
locals {
  # Default Routes
  default_tgw_routes = {
    internal_route = {
      cidr_block        = "10.160.0.0/11"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.inspection.tgw_attachment_ids.inspection
    }
    default_route = {
      cidr_block        = "0.0.0.0/0"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.egress.tgw_attachment_ids.egress
    }
    LAS_route = local.only_in_production >= 1 ? {
      cidr_block        = "10.0.0.0/16"
      tgw_attachment_id = module.dxg-01[0].dxg_attch_id
    } : null
    BOI_route = local.only_in_production >= 1 ? {
      cidr_block        = "10.100.0.0/16"
      tgw_attachment_id = module.dxg-01[0].dxg_attch_id
    } : null
    HQ_route = local.only_in_production >= 1 ? {
      cidr_block        = "10.200.0.0/16"
      tgw_attachment_id = module.dxg-01[0].dxg_attch_id
    } : null
    VPN_route = local.only_in_production >= 1 ? {
      cidr_block        = "172.16.128.0/18"
      tgw_attachment_id = module.dxg-01[0].dxg_attch_id
    } : null
  }

  # DXG Routes
  dxg_tgw_routes = {
    demo_1_route = {
      cidr_block        = "10.105.0.0/16"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.default.tgw_attachment_ids.demo_1
    }
    demo_2_route = {
      cidr_block        = "10.106.0.0/16"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.default.tgw_attachment_ids.demo_2
    }
  }

  # Inspection Routes
  inspection_tgw_routes = {
    demo_1_route = {
      cidr_block        = "10.105.0.0/16"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.default.tgw_attachment_ids.demo_1
    }
    demo_2_route = {
      cidr_block        = "10.106.0.0/16"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.default.tgw_attachment_ids.demo_2
    }
  }

  # Egress Routes
  egress_tgw_routes = {
    demo_1_route = {
      cidr_block        = "10.105.0.0/16"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.default.tgw_attachment_ids.demo_1
    }
    demo_2_route = {
      cidr_block        = "10.106.0.0/16"
      tgw_attachment_id = module.transit_gateway_usw2.tgw_resource_ids.default.tgw_attachment_ids.demo_2
    }
  }
}