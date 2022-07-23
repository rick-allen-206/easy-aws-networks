# TODO: Fix routing
# TODO: Move routes to YAML file
locals {
  default_routes = {
    public_routes = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = module.transit_gateway_usw2.tgw_id
      }
    ]
    private_routes = [
      {
        cidr_block         = "10.100.0.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.100.1.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.105.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.106.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "0.0.0.0/0"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
      }
    ]
  }



  inspection_routes = {
    firewall_routes = [
      {
        cidr_block         = "10.100.0.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.100.1.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.105.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.106.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
      }
    ]
    tgw_routes = [
      {
        cidr_block      = "10.100.0.0/24"
        vpc_endpoint_id = module.inspection-fw.firewall_attachment_ids
        }, {
        cidr_block      = "10.100.1.0/24"
        vpc_endpoint_id = module.inspection-fw.firewall_attachment_ids
        }, {
        cidr_block      = "10.105.0.0/16"
        vpc_endpoint_id = module.inspection-fw.firewall_attachment_ids
        }, {
        cidr_block      = "10.106.0.0/16"
        vpc_endpoint_id = module.inspection-fw.firewall_attachment_ids
      }
    ]
  }



  egress_routes = {
    public_routes = [
      {
        cidr_block      = "10.100.0.0/24"
        vpc_endpoint_id = module.egress-fw.firewall_attachment_ids
        }, {
        cidr_block      = "10.100.1.0/24"
        vpc_endpoint_id = module.egress-fw.firewall_attachment_ids
        }, {
        cidr_block      = "10.105.0.0/16"
        vpc_endpoint_id = module.egress-fw.firewall_attachment_ids
        }, {
        cidr_block      = "10.106.0.0/16"
        vpc_endpoint_id = module.egress-fw.firewall_attachment_ids
        }, {
        cidr_block = "0.0.0.0/0"
        gateway_id = module.egress_vpc.igw_id
      }
    ]
    firewall_routes = [
      {
        cidr_block         = "10.100.0.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.100.1.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.105.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.106.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = module.egress_vpc.natgw_ids # List of NAT Gateway IDs
      }
    ]
    private_routes = [
      {
        cidr_block         = "10.100.0.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.100.1.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.105.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.106.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block      = "0.0.0.0/0"
        vpc_endpoint_id = module.egress-fw.firewall_attachment_ids # List of NAT Gateway IDs
      }
    ]
    tgw_routes = [
      {
        cidr_block         = "10.100.0.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.100.1.0/24"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.105.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block         = "10.106.0.0/16"
        transit_gateway_id = module.transit_gateway_usw2.tgw_id
        }, {
        cidr_block      = "0.0.0.0/0"
        vpc_endpoint_id = module.egress-fw.firewall_attachment_ids # List of NAT Gateway IDs
      }
    ]
  }
}
