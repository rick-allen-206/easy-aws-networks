output "tgw_resource_ids" {
  description = "ID of the TGW resources"
  value       = module.transit_gateway_usw2.tgw_resource_ids
}

output "inspection_firewall_subnets" {
  description = "IDs of the firewall subnetss from the inspection VPC"
  value       = module.inspection_vpc.firewall_subnets
}

#####
# Generic outputs for VPCs
#####
output "demo_1_vpc" {
  description = "VPC Outputs"
  value = module.demo_1_vpc
}

output "demo_2_vpc" {
  description = "VPC Outputs"
  value = module.demo_2_vpc
}

#####
# Outputs for VPC IDs
#####

output "demo_1_vpc_id" {
  description = "VPC ID"
  value = module.demo_1_vpc.vpc_id
}

output "demo_2_vpc_id" {
  description = "VPC ID"
  value = module.demo_2_vpc.vpc_id
}

#####
# Outputs for subnet RAM share ARNs
#####

output "demo_1_private_sub_ram_arn" {
  description = "RAM share ARNs of the demo_1 private subnets"
  value = module.demo_1_private_sub_ram.ram_arn
}

output "demo_1_public_sub_ram_arn" {
  description = "RAM share ARNs of the demo_1 public subnets"
  value = module.demo_1_public_sub_ram.ram_arn
}

output "demo_2_private_sub_ram_arn" {
  description = "RAM share ARNs of the demo_2 private subnets"
  value = module.demo_2_private_sub_ram.ram_arn
}

output "demo_2_public_sub_ram_arn" {
  description = "RAM share ARNs of the demo_2 public subnets"
  value = module.demo_2_public_sub_ram.ram_arn
}