output "dxg_id" {
  description = "The ID of the gateway."
  value       = aws_dx_gateway.this.id
}

output "dxg_assoc_resource_id" {
  description = "The ID of the Direct Connect gateway association resource."
  value       = aws_dx_gateway_association.this.id
}

output "dxg_assoc_association_id" {
  description = "The ID of the Direct Connect gateway association."
  value       = aws_dx_gateway_association.this.dx_gateway_association_id
}

output "dxg_attch_id" {
  description = "ID of the Transit Gateway attachment to the Direct Connect Gateway"
  value       = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxg_assoc.id
}

output "tgw_rtb_id" {
  description = "ID of the Transit Gateway route table"
  value       = aws_ec2_transit_gateway_route_table.this.id
}

# output "dxg_transit_vif_id" {
#   description = "The ID of the virtual interface."
#   value       = aws_dx_transit_virtual_interface.this.id
# }

# output "dxg_transit_vif_aws_device" {
#   description = "The Direct Connect endpoint on which the virtual interface terminates."
#   value       = aws_dx_transit_virtual_interface.this.aws_device
# }
