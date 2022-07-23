module "inspection-fw" {
  source = "./modules/network_firewall/"
  # version = "~> 0.0.16"

  region        = var.region
  # tags          = local.default_tags
  firewall_name = "inspection-fw"
  vpc_id        = module.inspection_vpc.vpc_id
  subnet_ids    = module.inspection_vpc.firewall_subnets

  stateful_rule_order      = "STRICT_ORDER"
  stateful_default_actions = "drop_strict"

  stateless_default_actions          = "forward_to_sfe"
  stateless_fragment_default_actions = "forward_to_sfe"

  # domain_stateful_rule_group = [
  #   {
  #     capacity    = 100
  #     name        = "DOMAINSFEXAMPLE1"
  #     description = "Stateful rule example1 with domain list option"
  #     domain_list = ["test.example.com", "test1.example.com"]
  #     actions     = "DENYLIST"
  #     protocols   = ["HTTP_HOST", "TLS_SNI"]
  #   },
  #   {
  #     capacity    = 150
  #     name        = "DOMAINSFEXAMPLE2"
  #     description = "Stateful rule example2 with domain list option"
  #     domain_list = ["sample.example.com"]
  #     actions     = "ALLOWLIST"
  #     protocols   = ["HTTP_HOST"]
  #   },
  # ]

  # fivetuple_stateful_rule_group = [
  #   {
  #     capacity    = 100
  #     name        = "ALLOW-ICMP"
  #     description = "Stateful rule to allow ICMP"
  #     rule_config = [{
  #       protocol              = "ICMP"
  #       source_ipaddress      = "0.0.0.0/0"
  #       source_port           = "ANY"
  #       destination_ipaddress = "ANY"
  #       destination_port      = "ANY"
  #       direction             = "ANY"
  #       actions = {
  #         type = "drop"
  #       }
  #     }]
  #   },
  # ]
}

module "egress-fw" {
  source = "./modules/network_firewall/"
  # version = "~> 0.0.16"

  region        = var.region
  # tags          = local.default_tags
  firewall_name = "egress-fw"
  vpc_id        = module.egress_vpc.vpc_id
  subnet_ids    = module.egress_vpc.firewall_subnets

  stateful_rule_order      = "STRICT_ORDER"
  stateful_default_actions = "drop_strict"

  stateless_default_actions          = "forward_to_sfe"
  stateless_fragment_default_actions = "forward_to_sfe"
}

module "demo_1-fw" {
  source = "./modules/network_firewall/"
  # version = "~> 0.0.16"

  region        = var.region
  # tags          = local.default_tags
  firewall_name = "demo-1-fw"
  vpc_id        = module.demo_1_vpc.vpc_id
  subnet_ids    = module.demo_1_vpc.firewall_subnets

  stateful_rule_order      = "STRICT_ORDER"
  stateful_default_actions = "drop_strict"

  stateless_default_actions          = "forward_to_sfe"
  stateless_fragment_default_actions = "forward_to_sfe"
}

module "demo_2-fw" {
  source = "./modules/network_firewall/"
  # version = "~> 0.0.16"

  region        = var.region
  # tags          = local.default_tags
  firewall_name = "demo-2-fw"
  vpc_id        = module.demo_2_vpc.vpc_id
  subnet_ids    = module.demo_2_vpc.firewall_subnets

  stateful_rule_order      = "STRICT_ORDER"
  stateful_default_actions = "drop_strict"

  stateless_default_actions          = "forward_to_sfe"
  stateless_fragment_default_actions = "forward_to_sfe"
}