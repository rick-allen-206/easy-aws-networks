resource "aws_dx_gateway" "this" {
  name            = var.dxg_name
  amazon_side_asn = var.dxg_asn
}

resource "aws_dx_gateway_association" "this" {
  dx_gateway_id         = aws_dx_gateway.this.id
  associated_gateway_id = var.tgw_id
  
  allowed_prefixes      = var.allowed_prefixes
}

# TODO: add in VIF config
resource "aws_dx_transit_virtual_interface" "this" {
  for_each       = var.vif
  dx_gateway_id  = aws_dx_gateway.this.id

  name           = each.value.name
  connection_id  = each.value.connection_id
  vlan           = each.value.vlan
  bgp_asn        = each.value.bgp_asn
  bgp_auth_key   = each.value.bgp_auth_key 
  address_family = "ipv4"
}

data "aws_ec2_transit_gateway_dx_gateway_attachment" "dxg_assoc" {
  transit_gateway_id = var.tgw_id
  dx_gateway_id      = aws_dx_gateway.this.id
}

# Create Route Tables
resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.tgw_id
  tags = merge(
    { Name = "dxg-rt" },
    var.tags
  )
}

# Associate Transit Gateway route tables
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxg_assoc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

# Propogate attachment to route table
resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxg_assoc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

