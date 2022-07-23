output "tgw_id" {
  description = "ID of the TGW"
  value       = aws_ec2_transit_gateway.this.id
}

# output "resource_map" {
#   description = "meh"
#   value       = local.resource_map
# }

output "tgw_resource_ids" {
  description = "IDs of transite gateway attachments, route tables, and associations for each route table set"
  value       = module.tgw_attachments
}
