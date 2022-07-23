# TODO: check all outputs to make sure they're valid still
output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, "")
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this[0].arn, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, "")
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database[*].id
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = aws_subnet.database[*].arn
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = aws_subnet.database[*].cidr_block
}

output "firewall_subnets" {
  description = "List of IDs of firewall subnets"
  value       = aws_subnet.firewall[*].id
}

output "firewall_subnet_arns" {
  description = "List of ARNs of firewall subnets"
  value       = aws_subnet.firewall[*].arn
}

output "firewall_subnets_cidr_blocks" {
  description = "List of cidr_blocks of firewall subnets"
  value       = aws_subnet.firewall[*].cidr_block
}
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "tgw_subnets" {
  description = "List of IDs of tgw subnets"
  value       = aws_subnet.tgw[*].id
}

output "tgw_subnet_arns" {
  description = "List of ARNs of tgw subnets"
  value       = aws_subnet.tgw[*].arn
}

output "tgw_subnets_cidr_blocks" {
  description = "List of cidr_blocks of tgw subnets"
  value       = aws_subnet.tgw[*].cidr_block
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private[*].id
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = aws_route_table.database[*].id
}

output "tgw_route_table_ids" {
  description = "List of IDs of tgw route tables"
  value       = aws_route_table.tgw[*].id
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat[*].id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = var.reuse_nat_ips ? var.external_nat_ips : aws_eip.nat[*].public_ip
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, "")
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, "")
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress only Internet Gateway"
  value       = try(aws_egress_only_internet_gateway.this[0].id, "")
}

output "cgw_ids" {
  description = "List of IDs of Customer Gateway"
  value       = [for k, v in aws_customer_gateway.this : v.id]
}

output "cgw_arns" {
  description = "List of ARNs of Customer Gateway"
  value       = [for k, v in aws_customer_gateway.this : v.arn]
}

output "this_customer_gateway" {
  description = "Map of Customer Gateway attributes"
  value       = aws_customer_gateway.this
}

output "vgw_id" {
  description = "The ID of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].id, aws_vpn_gateway_attachment.this[0].vpn_gateway_id, "")
}

output "vgw_arn" {
  description = "The ARN of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].arn, "")
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = try(aws_network_acl.public[0].id, "")
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = try(aws_network_acl.public[0].arn, "")
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = try(aws_network_acl.private[0].id, "")
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = try(aws_network_acl.private[0].arn, "")
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = try(aws_network_acl.database[0].id, "")
}

output "database_network_acl_arn" {
  description = "ARN of the database network ACL"
  value       = try(aws_network_acl.database[0].arn, "")
}

output "tgw_network_acl_id" {
  description = "ID of the tgw network ACL"
  value       = try(aws_network_acl.tgw[0].id, "")
}

output "tgw_network_acl_arn" {
  description = "ARN of the tgw network ACL"
  value       = try(aws_network_acl.tgw[0].arn, "")
}

# VPC flow log
# output "vpc_flow_log_id" {
#   description = "The ID of the Flow Log resource"
#   value       = try(aws_flow_log.this[0].id, "")
# }

# output "vpc_flow_log_destination_arn" {
#   description = "The ARN of the destination for VPC Flow Logs"
#   value       = local.flow_log_destination_arn
# }

output "vpc_flow_log_destination_type" {
  description = "The type of the destination for VPC Flow Logs"
  value       = var.flow_log_destination_type
}

# output "vpc_flow_log_cloudwatch_iam_role_arn" {
#   description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
#   value       = local.flow_log_iam_role_arn
# }

# Static values (arguments)
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}

# output "egress_only_internet_gateway_id" {
#   description = "The ID of the egress only Internet Gateway"
#   value       = module.shared_vpc.igw_id
# }

# output "igw_id" {
#   description = "The ID of the Internet Gateway"
#   value       = module.shared_vpc.igw_id
# }

# output "natgw_ids" {
#   description = "List of NAT Gateway IDs"
#   value       = module.shared_vpc.natgw_ids
# }

# TODO: add private endpoint ID export

# output "vpc_cidr_block" {
#   description = "The CIDR block of the VPC"
#   value       = module.shared_vpc.vpc_cidr_block
# }

# output "private_subnets" {
#   description = "List of IDs of private subnets"
#   value       = module.shared_vpc.private_subnets
# }

# output "public_subnets" {
#   description = "List of IDs of public subnets"
#   value       = module.shared_vpc.public_subnets
# }

# output "tgw_subnets" {
#   description = "List of IDs of tgw subnets"
#   value       = module.shared_vpc.tgw_subnets
# }
