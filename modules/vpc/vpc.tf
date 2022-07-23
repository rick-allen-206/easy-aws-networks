locals {
  max_subnet_length = max(
    length(var.private_subnets)
  )
  # route_table_count = var.one_route_table_per_az ? length(var.azs) : 1

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this[0].id, "")

  create_vpc = var.create_vpc
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = local.create_vpc ? 1 : 0

  cidr_block                     = var.cidr
  instance_tenancy               = var.instance_tenancy
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_dns_support             = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = local.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  # Do not turn this into `local.vpc_id`
  vpc_id = aws_vpc.this[0].id

  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

resource "aws_default_security_group" "this" {
  count = local.create_vpc && var.manage_default_security_group ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self            = lookup(ingress.value, "self", null)
      cidr_blocks     = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      prefix_list_ids = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description     = lookup(ingress.value, "description", null)
      from_port       = lookup(ingress.value, "from_port", 0)
      to_port         = lookup(ingress.value, "to_port", 0)
      protocol        = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self            = lookup(egress.value, "self", null)
      cidr_blocks     = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      prefix_list_ids = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups = compact(split(",", lookup(egress.value, "security_groups", "")))
      description     = lookup(egress.value, "description", null)
      from_port       = lookup(egress.value, "from_port", 0)
      to_port         = lookup(egress.value, "to_port", 0)
      protocol        = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = merge(
    { "Name" = coalesce(var.default_security_group_name, var.name) },
    var.tags,
    var.default_security_group_tags,
  )
}

################################################################################
# DHCP Options Set
################################################################################

resource "aws_vpc_dhcp_options" "this" {
  count = local.create_vpc && var.enable_dhcp_options ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.dhcp_options_tags,
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = local.create_vpc && var.enable_dhcp_options ? 1 : 0

  vpc_id          = local.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = local.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}

resource "aws_egress_only_internet_gateway" "this" {
  count = local.create_vpc && var.create_egress_only_igw && local.max_subnet_length > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}


# TODO: Possibly add NAT Gateway subnet
# TODO: Fix subnets to show AZ in the name
################################################################################
# Public subnet
################################################################################

resource "aws_subnet" "public" {
  count = local.create_vpc && length(var.public_subnets) > 0 && (length(var.public_subnets) == length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = var.one_public_route_table_per_az ? format(
        "${var.name}-${var.public_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.public_subnet_suffix}"
    },
    var.tags,
    var.public_subnet_tags,
  )
}

################################################################################
# Firewall subnet - subnet to contain firewalls
################################################################################

resource "aws_subnet" "firewall" {
  count = local.create_vpc && length(var.firewall_subnets) > 0 ? length(var.firewall_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.firewall_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = var.one_firewall_route_table_per_az ? format(
        "${var.name}-${var.firewall_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.firewall_subnet_suffix}"
    },
    var.tags,
    var.firewall_subnet_tags,
  )
}

################################################################################
# Private subnet
################################################################################

resource "aws_subnet" "private" {
  count = local.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.private_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = var.one_private_route_table_per_az ? format(
        "${var.name}-${var.private_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.private_subnet_suffix}"
    },
    var.tags,
    var.private_subnet_tags,
  )
}

################################################################################
# Database subnet
################################################################################

# TODO: why is database route table being created when no subnet is specified?
resource "aws_subnet" "database" {
  count = local.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.database_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = var.one_database_route_table_per_az ? format(
        "${var.name}-${var.database_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.database_subnet_suffix}"
    },
    var.tags,
    var.database_subnet_tags,
  )
}


################################################################################
# TGW subnets - subnets to container transit gateway attachments
################################################################################

resource "aws_subnet" "tgw" {
  count = local.create_vpc && length(var.tgw_subnets) > 0 ? length(var.tgw_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.tgw_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = var.one_tgw_route_table_per_az ? format(
        "${var.name}-${var.tgw_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.tgw_subnet_suffix}"
    },
    var.tags,
    var.tgw_subnet_tags,
  )
}

################################################################################
# IGW route
################################################################################

resource "aws_route_table" "igw" {
  count = local.create_vpc && var.create_igw && length(var.firewall_subnets) > 0 && var.create_igw_rt == true ? 1 : 0

  vpc_id = local.vpc_id

  dynamic "route" {
    for_each = var.igw_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block = route.value.cidr_block

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      # vpc_endpoint_id = (
      #   lookup(route.value, "vpc_endpoint_id", null) != null ?
      #   element([ 
      #     for i in range(length(var.azs)) : route.value.vpc_endpoint_id.endpoint_id if route.value.vpc_endpoint_id.availability_zone == var.azs[i]
      #   ], 0) :
      #   null
      # )
    }
  }

  tags = merge(
    {
      "Name" = "${var.name}-igw"
    },
    var.tags,
    var.igw_route_table_tags,
  )
}

################################################################################
# Default route
################################################################################

resource "aws_default_route_table" "default" {
  count = local.create_vpc && var.manage_default_route_table ? 1 : 0

  default_route_table_id = aws_vpc.this[0].default_route_table_id
  propagating_vgws       = var.default_route_table_propagating_vgws

  dynamic "route" {
    for_each = var.default_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block = route.value.cidr_block

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = try(element(lookup(route.value, "nat_gateway_id", null), count.index), null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      # TODO: Enable more than just firewall endpoints (the problem is that the eid is assigned if the subnet ID in the map matches the subnet ID of the firewall_subnet[count.index])
      vpc_endpoint_id = (
        lookup(route.value, "vpc_endpoint_id", null) != null ?
        element([for i in route.value.vpc_endpoint_id :
          i.endpoint_id if
          i.subnet_id == aws_subnet.public[count.index].id ||
          i.subnet_id == aws_subnet.firewall[count.index].id ||
          i.subnet_id == aws_subnet.tgw[count.index].id ||
          i.subnet_id == aws_subnet.private[count.index].id
        ], 0) :
        null
      )
    }
  }


  timeouts {
    create = "5m"
    update = "5m"
  }

  tags = merge(
    { "Name" = coalesce(var.default_route_table_name, var.name) },
    var.tags,
    var.default_route_table_tags,
  )
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "public" {
  count = local.create_vpc && length(var.public_subnets) > 0 ? ( var.one_public_route_table_per_az ? length(var.public_subnets) : 1 ) : 0

  vpc_id = local.vpc_id

  dynamic "route" {
    for_each = var.public_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block = route.value.cidr_block

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = try(element(lookup(route.value, "nat_gateway_id", null), count.index), null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      # TODO: Enable more than just firewall endpoints (the problem is that the eid is assigned if the subnet ID in the map matches the subnet ID of the firewall_subnet[count.index])
      vpc_endpoint_id = (
        lookup(route.value, "vpc_endpoint_id", null) != null ?
        element([for i in route.value.vpc_endpoint_id :
          i.endpoint_id if
          # TODO: add try block here? It seems like if all of these aren't present then it will fail if they're ever called out of order. 
          # TODO: fix ordering to match
          i.subnet_id == aws_subnet.private[count.index].id ||
          i.subnet_id == aws_subnet.public[count.index].id ||
          i.subnet_id == aws_subnet.firewall[count.index].id ||
          i.subnet_id == aws_subnet.tgw[count.index].id
        ], 0) :
        null
      )
    }
  }

  tags = merge(
    {
      "Name" = var.one_public_route_table_per_az ? format(
        "${var.name}-${var.public_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.public_subnet_suffix}"
    },
    var.tags,
    var.public_route_table_tags,
  )
}

################################################################################
# Firewall routes
################################################################################

# TODO: add unique endpoint_id option for firewall endpoints with conditional to compare the subnet ids before assigning the endpoint id
resource "aws_route_table" "firewall" {
  count = local.create_vpc && length(var.firewall_subnets) > 0 ? ( var.one_firewall_route_table_per_az ? length(var.firewall_subnets) : 1 ) : 0

  vpc_id = local.vpc_id

  dynamic "route" {
    for_each = var.firewall_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block = route.value.cidr_block

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = try(element(lookup(route.value, "nat_gateway_id", null), count.index), null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      # TODO: Enable more than just firewall endpoints (the problem is that the eid is assigned if the subnet ID in the map matches the subnet ID of the firewall_subnet[count.index])
      vpc_endpoint_id = (
        lookup(route.value, "vpc_endpoint_id", null) != null ?
        element([for i in route.value.vpc_endpoint_id :
          i.endpoint_id if
          i.subnet_id == aws_subnet.private[count.index].id ||
          i.subnet_id == aws_subnet.public[count.index].id ||
          i.subnet_id == aws_subnet.firewall[count.index].id ||
          i.subnet_id == aws_subnet.tgw[count.index].id
        ], 0) :
        null
      )
    }
  }

  tags = merge(
    {
      "Name" = var.one_firewall_route_table_per_az ? format(
        "${var.name}-${var.firewall_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.firewall_subnet_suffix}"
    },
    var.tags,
    var.firewall_route_table_tags,
  )
}

################################################################################
# Private routes
# There are as many routing tables as the number of NAT gateways
################################################################################

resource "aws_route_table" "private" {
  count = local.create_vpc && length(var.private_subnets) > 0 ? ( var.one_private_route_table_per_az ? length(var.private_subnets) : 1 ) : 0

  vpc_id = local.vpc_id

  dynamic "route" {
    for_each = var.private_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block = route.value.cidr_block

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = try(element(lookup(route.value, "nat_gateway_id", null), count.index), null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      # TODO: Enable more than just firewall endpoints (the problem is that the eid is assigned if the subnet ID in the map matches the subnet ID of the firewall_subnet[count.index])
      vpc_endpoint_id = (
        lookup(route.value, "vpc_endpoint_id", null) != null ?
        element([for i in route.value.vpc_endpoint_id :
          i.endpoint_id if
          i.subnet_id == aws_subnet.private[count.index].id ||
          i.subnet_id == aws_subnet.public[count.index].id ||
          i.subnet_id == aws_subnet.firewall[count.index].id ||
          i.subnet_id == aws_subnet.tgw[count.index].id
        ], 0) :
        null
      )
    }
  }

  tags = merge(
    {
      "Name" = var.one_private_route_table_per_az ? format(
        "${var.name}-${var.private_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.private_subnet_suffix}"
    },
    var.tags,
    var.private_route_table_tags,
  )
}

################################################################################
# Database routes
################################################################################

resource "aws_route_table" "database" {
  count = local.create_vpc && length(var.database_subnets) > 0 ? ( var.one_database_route_table_per_az ? length(var.database_subnets) : 1 ) : 0

  vpc_id = local.vpc_id

  dynamic "route" {
    for_each = var.database_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block = route.value.cidr_block

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = try(element(lookup(route.value, "nat_gateway_id", null), count.index), null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      # TODO: Enable more than just firewall endpoints (the problem is that the eid is assigned if the subnet ID in the map matches the subnet ID of the firewall_subnet[count.index])
      vpc_endpoint_id = (
        lookup(route.value, "vpc_endpoint_id", null) != null ?
        element([for i in route.value.vpc_endpoint_id :
          i.endpoint_id if
          i.subnet_id == aws_subnet.database[count.index].id ||
          i.subnet_id == aws_subnet.public[count.index].id ||
          i.subnet_id == aws_subnet.firewall[count.index].id ||
          i.subnet_id == aws_subnet.tgw[count.index].id
        ], 0) :
        null
      )
    }
  }

  tags = merge(
    {
      "Name" = var.one_database_route_table_per_az ? format(
        "${var.name}-${var.database_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.database_subnet_suffix}"
    },
    var.tags,
    var.database_route_table_tags,
  )
}

################################################################################
# TGW routes
################################################################################

resource "aws_route_table" "tgw" {
  count = local.create_vpc && length(var.tgw_subnets) > 0 ? ( var.one_tgw_route_table_per_az ? length(var.tgw_subnets) : 1 ) : 0

  vpc_id = local.vpc_id

  dynamic "route" {
    for_each = var.tgw_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block = route.value.cidr_block

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = try(element(lookup(route.value, "nat_gateway_id", null), count.index), null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      # TODO: Enable more than just firewall endpoints (the problem is that the eid is assigned if the subnet ID in the map matches the subnet ID of the firewall_subnet[count.index])
      vpc_endpoint_id = (
        lookup(route.value, "vpc_endpoint_id", null) != null ?
        element([for i in route.value.vpc_endpoint_id :
          i.endpoint_id if
          try(i.subnet_id == aws_subnet.private[count.index].id, false) ||
          try(i.subnet_id == aws_subnet.public[count.index].id, false) ||
          try(i.subnet_id == aws_subnet.firewall[count.index].id, false) ||
          try(i.subnet_id == aws_subnet.tgw[count.index].id, false)
        ], 0) :
        null
      )
    }
  }

  tags = merge(
    {
      "Name" = var.one_tgw_route_table_per_az ? format(
        "${var.name}-${var.tgw_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.tgw_subnet_suffix}"
    },
    var.tags,
    var.tgw_route_table_tags,
  )
}


################################################################################
# Route Table Association
################################################################################

resource "aws_route_table_association" "igw" {
  count = local.create_vpc && var.create_igw && length(var.firewall_subnets) > 0 && var.create_igw_rt == true ? 1 : 0

  gateway_id     = aws_internet_gateway.this[0].id
  route_table_id = aws_route_table.igw[0].id
}

resource "aws_route_table_association" "public" {
  count = local.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route_table_association" "firewall" {
  count = local.create_vpc && length(var.firewall_subnets) > 0 ? length(var.firewall_subnets) : 0

  subnet_id      = element(aws_subnet.firewall[*].id, count.index)
  route_table_id = element(aws_route_table.firewall[*].id, count.index)
}

resource "aws_route_table_association" "private" {
  count = local.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route_table_association" "tgw" {
  count = local.create_vpc && length(var.tgw_subnets) > 0 ? length(var.tgw_subnets) : 0

  subnet_id      = element(aws_subnet.tgw[*].id, count.index)
  route_table_id = element(aws_route_table.tgw[*].id, count.index)
}

################################################################################
# Default Network ACLs
################################################################################

resource "aws_default_network_acl" "this" {
  count = local.create_vpc && var.manage_default_network_acl ? 1 : 0

  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  # subnet_ids is using lifecycle ignore_changes, so it is not necessary to list
  # any explicitly. See https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/736.
  subnet_ids = null

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action     = ingress.value.action
      cidr_block = lookup(ingress.value, "cidr_block", null)
      from_port  = ingress.value.from_port
      icmp_code  = lookup(ingress.value, "icmp_code", null)
      icmp_type  = lookup(ingress.value, "icmp_type", null)
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      to_port    = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action     = egress.value.action
      cidr_block = lookup(egress.value, "cidr_block", null)
      from_port  = egress.value.from_port
      icmp_code  = lookup(egress.value, "icmp_code", null)
      icmp_type  = lookup(egress.value, "icmp_type", null)
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      to_port    = egress.value.to_port
    }
  }

  tags = merge(
    { "Name" = coalesce(var.default_network_acl_name, var.name) },
    var.tags,
    var.default_network_acl_tags,
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

################################################################################
# Public Network ACLs
################################################################################

resource "aws_network_acl" "public" {
  count = local.create_vpc && var.public_dedicated_network_acl && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id     = local.vpc_id
  subnet_ids = aws_subnet.public[*].id

  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}" },
    var.tags,
    var.public_acl_tags,
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  count = local.create_vpc && var.public_dedicated_network_acl && length(var.public_subnets) > 0 ? length(var.public_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.public[0].id

  egress      = false
  rule_number = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.public_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.public_inbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  count = local.create_vpc && var.public_dedicated_network_acl && length(var.public_subnets) > 0 ? length(var.public_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.public[0].id

  egress      = true
  rule_number = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_outbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.public_outbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.public_outbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.public_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.public_outbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.public_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.public_outbound_acl_rules[count.index], "cidr_block", null)
}

################################################################################
# Firewall Network ACLs
################################################################################

resource "aws_network_acl" "firewall" {
  count = local.create_vpc && var.firewall_dedicated_network_acl && length(var.firewall_subnets) > 0 ? 1 : 0

  vpc_id     = local.vpc_id
  subnet_ids = aws_subnet.firewall[*].id

  tags = merge(
    { "Name" = "${var.name}-${var.firewall_subnet_suffix}" },
    var.tags,
    var.firewall_acl_tags,
  )
}

resource "aws_network_acl_rule" "firewall_inbound" {
  count = local.create_vpc && var.firewall_dedicated_network_acl && length(var.firewall_subnets) > 0 ? length(var.firewall_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.firewall[0].id

  egress      = false
  rule_number = var.firewall_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.firewall_inbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.firewall_inbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.firewall_inbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.firewall_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.firewall_inbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.firewall_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.firewall_inbound_acl_rules[count.index], "cidr_block", null)
}

resource "aws_network_acl_rule" "firewall_outbound" {
  count = local.create_vpc && var.firewall_dedicated_network_acl && length(var.firewall_subnets) > 0 ? length(var.firewall_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.firewall[0].id

  egress      = true
  rule_number = var.firewall_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.firewall_outbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.firewall_outbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.firewall_outbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.firewall_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.firewall_outbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.firewall_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.firewall_outbound_acl_rules[count.index], "cidr_block", null)
}

################################################################################
# Private Network ACLs
################################################################################

resource "aws_network_acl" "private" {
  count = local.create_vpc && var.private_dedicated_network_acl && length(var.private_subnets) > 0 ? 1 : 0

  vpc_id     = local.vpc_id
  subnet_ids = aws_subnet.private[*].id

  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}" },
    var.tags,
    var.private_acl_tags,
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  count = local.create_vpc && var.private_dedicated_network_acl && length(var.private_subnets) > 0 ? length(var.private_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress      = false
  rule_number = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.private_inbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.private_inbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.private_inbound_acl_rules[count.index], "cidr_block", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  count = local.create_vpc && var.private_dedicated_network_acl && length(var.private_subnets) > 0 ? length(var.private_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress      = true
  rule_number = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.private_outbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.private_outbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.private_outbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.private_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.private_outbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.private_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.private_outbound_acl_rules[count.index], "cidr_block", null)
}

################################################################################
# Database Network ACLs
################################################################################

resource "aws_network_acl" "database" {
  count = local.create_vpc && var.database_dedicated_network_acl && length(var.database_subnets) > 0 ? 1 : 0

  vpc_id     = local.vpc_id
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    { "Name" = "${var.name}-${var.database_subnet_suffix}" },
    var.tags,
    var.database_acl_tags,
  )
}

resource "aws_network_acl_rule" "database_inbound" {
  count = local.create_vpc && var.database_dedicated_network_acl && length(var.database_subnets) > 0 ? length(var.database_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.database[0].id

  egress      = false
  rule_number = var.database_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.database_inbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.database_inbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.database_inbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.database_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.database_inbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.database_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.database_inbound_acl_rules[count.index], "cidr_block", null)
}

resource "aws_network_acl_rule" "database_outbound" {
  count = local.create_vpc && var.database_dedicated_network_acl && length(var.database_subnets) > 0 ? length(var.database_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.database[0].id

  egress      = true
  rule_number = var.database_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.database_outbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.database_outbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.database_outbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.database_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.database_outbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.database_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.database_outbound_acl_rules[count.index], "cidr_block", null)
}

################################################################################
# TGW Network ACLs
################################################################################

resource "aws_network_acl" "tgw" {
  count = local.create_vpc && var.tgw_dedicated_network_acl && length(var.tgw_subnets) > 0 ? 1 : 0

  vpc_id     = local.vpc_id
  subnet_ids = aws_subnet.tgw[*].id

  tags = merge(
    { "Name" = "${var.name}-${var.tgw_subnet_suffix}" },
    var.tags,
    var.tgw_acl_tags,
  )
}

resource "aws_network_acl_rule" "tgw_inbound" {
  count = local.create_vpc && var.tgw_dedicated_network_acl && length(var.tgw_subnets) > 0 ? length(var.tgw_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.tgw[0].id

  egress      = false
  rule_number = var.tgw_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.tgw_inbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.tgw_inbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.tgw_inbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.tgw_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.tgw_inbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.tgw_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.tgw_inbound_acl_rules[count.index], "cidr_block", null)
}

resource "aws_network_acl_rule" "tgw_outbound" {
  count = local.create_vpc && var.tgw_dedicated_network_acl && length(var.tgw_subnets) > 0 ? length(var.tgw_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.tgw[0].id

  egress      = true
  rule_number = var.tgw_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.tgw_outbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.tgw_outbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.tgw_outbound_acl_rules[count.index], "to_port", null)
  icmp_code   = lookup(var.tgw_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type   = lookup(var.tgw_outbound_acl_rules[count.index], "icmp_type", null)
  protocol    = var.tgw_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.tgw_outbound_acl_rules[count.index], "cidr_block", null)
}

################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : try(aws_eip.nat[*].id, [])
}

resource "aws_eip" "nat" {
  count = local.create_vpc && var.enable_nat_gateway && false == var.reuse_nat_ips ? length(var.azs) : 0

  vpc = true

  tags = merge(
    {
      "Name" = format(
        "${var.name}-%s",
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
    var.nat_eip_tags,
  )
}

resource "aws_nat_gateway" "this" {
  count = local.create_vpc && var.enable_nat_gateway ? length(var.azs) : 0

  allocation_id = element(
    local.nat_gateway_ips,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )

  tags = merge(
    {
      "Name" = format(
        "${var.name}-%s",
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
    var.nat_gateway_tags,
  )

  depends_on = [aws_internet_gateway.this]
}

################################################################################
# Customer Gateways
################################################################################

resource "aws_customer_gateway" "this" {
  for_each = var.customer_gateways

  bgp_asn     = each.value["bgp_asn"]
  ip_address  = each.value["ip_address"]
  device_name = lookup(each.value, "device_name", null)
  type        = "ipsec.1"

  tags = merge(
    { Name = "${var.name}-${each.key}" },
    var.tags,
    var.customer_gateway_tags,
  )
}

################################################################################
# VPN Gateway
################################################################################

resource "aws_vpn_gateway" "this" {
  count = local.create_vpc && var.enable_vpn_gateway ? 1 : 0

  vpc_id            = local.vpc_id
  amazon_side_asn   = var.amazon_side_asn
  availability_zone = var.vpn_gateway_az

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpn_gateway_tags,
  )
}

resource "aws_vpn_gateway_attachment" "this" {
  count = var.vpn_gateway_id != "" ? 1 : 0

  vpc_id         = local.vpc_id
  vpn_gateway_id = var.vpn_gateway_id
}

resource "aws_vpn_gateway_route_propagation" "public" {
  count = local.create_vpc && var.propagate_public_route_tables_vgw && (var.enable_vpn_gateway || var.vpn_gateway_id != "") ? 1 : 0

  route_table_id = element(aws_route_table.public[*].id, count.index)
  vpn_gateway_id = element(
    concat(
      aws_vpn_gateway.this[*].id,
      aws_vpn_gateway_attachment.this[*].vpn_gateway_id,
    ),
    count.index,
  )
}

resource "aws_vpn_gateway_route_propagation" "private" {
  count = local.create_vpc && var.propagate_private_route_tables_vgw && (var.enable_vpn_gateway || var.vpn_gateway_id != "") ? length(var.private_subnets) : 0

  route_table_id = element(aws_route_table.private[*].id, count.index)
  vpn_gateway_id = element(
    concat(
      aws_vpn_gateway.this[*].id,
      aws_vpn_gateway_attachment.this[*].vpn_gateway_id,
    ),
    count.index,
  )
}

resource "aws_vpn_gateway_route_propagation" "tgw" {
  count = local.create_vpc && var.propagate_tgw_route_tables_vgw && (var.enable_vpn_gateway || var.vpn_gateway_id != "") ? length(var.tgw_subnets) : 0

  route_table_id = element(aws_route_table.tgw[*].id, count.index)
  vpn_gateway_id = element(
    concat(
      aws_vpn_gateway.this[*].id,
      aws_vpn_gateway_attachment.this[*].vpn_gateway_id,
    ),
    count.index,
  )
}

################################################################################
# Defaults
################################################################################

resource "aws_default_vpc" "this" {
  count = var.manage_default_vpc ? 1 : 0

  enable_dns_support   = var.default_vpc_enable_dns_support
  enable_dns_hostnames = var.default_vpc_enable_dns_hostnames
  enable_classiclink   = var.default_vpc_enable_classiclink

  tags = merge(
    { "Name" = coalesce(var.default_vpc_name, "default") },
    var.tags,
    var.default_vpc_tags,
  )
}
