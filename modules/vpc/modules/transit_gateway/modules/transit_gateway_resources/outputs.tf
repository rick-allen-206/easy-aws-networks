output "tgw_attachment_ids" {
  description = "ID of the TGW attachments"
  value = {
    for k, v in aws_ec2_transit_gateway_vpc_attachment.this : k => v.id
  }
}

output "tgw_rtb_id" {
  description = "ID of the Transit Gateway route table"
  value       = aws_ec2_transit_gateway_route_table.this.id
}

output "tgw_association_ids" {
  description = "ID of the TGW associations"
  value = {
    for k, v in aws_ec2_transit_gateway_route_table_association.this : k => v.id
  }
}

# TODO: remove?
# output "tgw_propagation_id" {
#   description = "EC2 Transit Gateway Route Table identifier combined with EC2 Transit Gateway Attachment identifier"
#   value       = "${var.default_rt_assoc == false ? aws_ec2_transit_gateway_route_table_propagation.this[0].id : null}"
# }
