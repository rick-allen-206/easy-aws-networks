# TODO: Loop this to clean it up
module "demo_1_private_sub_ram" {
  source = "./modules/vpc/modules/ram/"
  # version = "~> 0.0.95"

  ram_name      = "demo_1-private-subnets"
  resource_arns = module.demo_1_vpc.private_subnet_arns
  # tags          = local.default_tags
}

module "demo_1_public_sub_ram" {
  source = "./modules/vpc/modules/ram/"
  # version = "~> 0.0.95"

  ram_name      = "demo_1-public-subnets"
  resource_arns = module.demo_1_vpc.public_subnet_arns
  # tags          = local.default_tags
}

module "demo_2_private_sub_ram" {
  source = "./modules/vpc/modules/ram/"
  # version = "~> 0.0.95"

  ram_name      = "demo_2-private-subnets"
  resource_arns = module.demo_2_vpc.private_subnet_arns
  # tags          = local.default_tags
}

module "demo_2_public_sub_ram" {
  source = "./modules/vpc/modules/ram/"
  # version = "~> 0.0.95"

  ram_name      = "demo_2-public-subnets"
  resource_arns = module.demo_2_vpc.public_subnet_arns
  # tags          = local.default_tags
}