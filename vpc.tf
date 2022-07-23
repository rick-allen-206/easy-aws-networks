module "inspection_vpc" {
  source = "./modules/vpc/"

  # VPC
  name                  = "${local.region_shorthand}-inspection_vpc"
  cidr                  = "10.100.0.0/24"
  secondary_cidr_blocks = ["10.101.8.0/23"]

  one_tgw_route_table_per_az      = true
  one_firewall_route_table_per_az = true


  # Subnets
  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
    "${var.region}d"
  ]
  # tgw_subnet_tags   = local.tgw_subnet_tags
  tgw_subnets = [
    "10.101.9.0/28",
    "10.101.9.16/28",
    "10.101.9.32/28",
    "10.101.9.48/28"
  ]
  # private_subnet_tags = local.private_subnet_tags
  firewall_subnets = [
    "10.100.0.0/26",
    "10.100.0.64/26",
    "10.100.0.128/26",
    "10.100.0.192/26"
  ]

  # Network ACLs 
  manage_default_network_acl  = true
  default_network_acl_ingress = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.inbound)
  default_network_acl_egress  = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.outbound)

  # NAT Gatway
  enable_nat_gateway = false
  single_nat_gateway = false

  # Internet Gateway
  create_igw = false


  # Routes
  firewall_route_table_routes = local.inspection_routes.firewall_routes
  tgw_route_table_routes      = local.inspection_routes.tgw_routes
}



module "egress_vpc" {
  source = "./modules/vpc/"

  # VPC
  name                  = "${local.region_shorthand}-egress_vpc"
  cidr                  = "10.100.1.0/24"
  secondary_cidr_blocks = ["10.101.10.0/23"]
  # tags     = [null]

  one_public_route_table_per_az   = true
  one_firewall_route_table_per_az = true
  one_tgw_route_table_per_az      = true

  # Subnets
  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
    "${var.region}d"
  ]

  # tgw_subnet_tags   = local.tgw_subnet_tags
  tgw_subnets = [
    "10.101.10.0/28",
    "10.101.10.16/28",
    "10.101.10.32/28",
    "10.101.10.48/28"
  ]
  # firewall_subnet_tags  = local.firewall_subnet_tags
  firewall_subnets = [
    "10.101.10.64/28",
    "10.101.10.80/28",
    "10.101.10.96/28",
    "10.101.10.112/28"
  ]
  # public_subnet_tags  = local.public_subnet_tags
  public_subnets = [
    "10.101.11.0/26",
    "10.101.11.64/26",
    "10.101.11.128/26",
    "10.101.11.192/26"
  ]
  # private_subnet_tags = local.private_subnet_tags
  private_subnets = [
    "10.100.1.0/26",
    "10.100.1.64/26",
    "10.100.1.128/26",
    "10.100.1.192/26"
  ]

  # Network ACLs 
  manage_default_network_acl  = true
  default_network_acl_ingress = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.inbound)
  default_network_acl_egress  = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.outbound)

  # NAT Gatway
  single_nat_gateway = false
  enable_nat_gateway = true

  # Internet Gateway
  create_igw = true

  # Routes
  public_route_table_routes   = local.egress_routes.public_routes
  firewall_route_table_routes = local.egress_routes.firewall_routes
  private_route_table_routes  = local.egress_routes.private_routes
  tgw_route_table_routes      = local.egress_routes.tgw_routes
}



module "demo_1_vpc" {
  source = "./modules/vpc/"

  # VPC
  name                  = "${local.region_shorthand}-demo_1_vpc"
  cidr                  = "10.105.0.0/16"
  secondary_cidr_blocks = ["10.101.0.0/23"]

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnets
  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
    "${var.region}d"
  ]

  # tgw_subnet_tags   = local.tgw_subnet_tags
  tgw_subnets = [
    "10.101.1.0/28",
    "10.101.1.16/28",
    "10.101.1.32/28",
    "10.101.1.48/28"
  ]
  # firewall_subnet_tags  = local.firewall_subnet_tags
  firewall_subnets = [
    "10.101.1.64/28",
    "10.101.1.80/28",
    "10.101.1.96/28",
    "10.101.1.112/28"
  ] # public_subnet_tags  = local.public_subnet_tags
  public_subnets = [
    "10.101.0.0/26",
    "10.101.0.64/26",
    "10.101.0.128/26",
    "10.101.0.192/26"
  ]
  # private_subnet_tags = local.private_subnet_tags
  private_subnets = [
    "10.105.0.0/18",
    "10.105.64.0/18",
    "10.105.128.0/18",
    "10.105.192.0/18"
  ]
  # database_subnet_tags = local.database_subnet_tags
  database_subnets = [
    "10.101.1.128/28",
    "10.101.1.144/28",
    "10.101.1.160/28",
    "10.101.1.176/28"
  ]

  # Network ACLs 
  manage_default_network_acl  = true
  default_network_acl_ingress = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.inbound)
  default_network_acl_egress  = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.outbound)

  # NAT Gatway
  single_nat_gateway = false
  enable_nat_gateway = false

  # Internet Gateway
  create_igw    = true
  create_igw_rt = true

  # Routes
  igw_route_table_routes = [
    { cidr_block = "10.101.0.0/26", vpc_endpoint_id = { for i in module.demo_1-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}a"].endpoint_id },
    { cidr_block = "10.101.0.64/26", vpc_endpoint_id = { for i in module.demo_1-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}b"].endpoint_id },
    { cidr_block = "10.101.0.128/26", vpc_endpoint_id = { for i in module.demo_1-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}c"].endpoint_id },
    { cidr_block = "10.101.0.192/26", vpc_endpoint_id = { for i in module.demo_1-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}d"].endpoint_id },
  ]
  private_route_table_routes = local.default_routes.private_routes
  tgw_route_table_routes     = local.default_routes.tgw_routes
  public_route_table_routes = [{
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = module.demo_1-fw.firewall_attachment_ids
  }]
  firewall_route_table_routes = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = module.demo_1_vpc.igw_id
  }]
}



module "demo_2_vpc" {
  source = "./modules/vpc/"

  # VPC
  name                  = "${local.region_shorthand}-demo_2_vpc"
  cidr                  = "10.106.0.0/16"
  secondary_cidr_blocks = ["10.101.2.0/23"]

  # tags     = [null]

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnets
  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
    "${var.region}d"
  ]

  # tgw_subnet_tags   = local.tgw_subnet_tags
  tgw_subnets = [
    "10.101.2.0/28",
    "10.101.2.16/28",
    "10.101.2.32/28",
    "10.101.2.48/28"
  ]
  # firewall_subnet_tags  = local.firewall_subnet_tags
  firewall_subnets = [
    "10.101.2.64/28",
    "10.101.2.80/28",
    "10.101.2.96/28",
    "10.101.2.112/28"
  ]
  # public_subnet_tags  = local.public_subnet_tags
  public_subnets = [
    "10.101.3.0/26",
    "10.101.3.64/26",
    "10.101.3.128/26",
    "10.101.3.192/26"
  ]
  # private_subnet_tags = local.private_subnet_tags
  private_subnets = [
    "10.106.0.0/18",
    "10.106.64.0/18",
    "10.106.128.0/18",
    "10.106.192.0/18"
  ]

  # Network ACLs 
  manage_default_network_acl  = true
  default_network_acl_ingress = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.inbound)
  default_network_acl_egress  = concat(yamldecode(file("./acls/default_acls.yaml")).acls.default.outbound)

  # NAT Gatway
  single_nat_gateway = false
  enable_nat_gateway = false

  # Internet Gateway
  create_igw    = true
  create_igw_rt = true

  # Routes
  igw_route_table_routes = [
    { cidr_block = "10.101.3.0/26", vpc_endpoint_id = { for i in module.demo_2-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}a"].endpoint_id },
    { cidr_block = "10.101.3.64/26", vpc_endpoint_id = { for i in module.demo_2-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}b"].endpoint_id },
    { cidr_block = "10.101.3.128/26", vpc_endpoint_id = { for i in module.demo_2-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}c"].endpoint_id },
    { cidr_block = "10.101.3.192/26", vpc_endpoint_id = { for i in module.demo_2-fw.firewall_attachment_ids : i.availability_zone => i }["${var.region}d"].endpoint_id },
  ]
  private_route_table_routes = local.default_routes.private_routes
  tgw_route_table_routes     = local.default_routes.tgw_routes
  public_route_table_routes = [{
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = module.demo_2-fw.firewall_attachment_ids
  }]
  firewall_route_table_routes = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = module.demo_2_vpc.igw_id
  }]
}
