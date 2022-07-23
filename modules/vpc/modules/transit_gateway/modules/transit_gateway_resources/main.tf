locals {
  rt_detail_map = { for i in var.rt_details : i.name => i }
}

# Create Transit Gateway attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = local.rt_detail_map

  vpc_id                                          = each.value.vpc_id
  subnet_ids                                      = each.value.subnet_ids
  transit_gateway_id                              = var.transit_gateway_id
  appliance_mode_support                          = each.value.appliance_mode
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = merge(
    { Name = "${var.region}-tgw-01-${each.value.name}-attach" },
    var.tags,
    # each.value.attachment_tags,
  )
}

# Create Route Tables
resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.transit_gateway_id

  tags = merge(
    { Name = "${var.rt_name}-rt" },
    var.tags,
    # each.value.attachment_tags,
  )
}

# Associate Transit Gateway route tables
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = local.rt_detail_map

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

# TODO: remove?
# Propogate attachment to route table
# resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
#   count                          = var.rt_association == true ? 0 : 1
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
# }
