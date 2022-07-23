locals {
  endpoint_tags = {}
}

################################################################################
# VPC Endpoints Module
################################################################################
module "demo_1_endpoints" {
  source = "./modules/vpc/modules/endpoints/"

  vpc_id             = module.demo_1_vpc.vpc_id
  security_group_ids = [data.aws_security_group.demo_1_default.id]
  create = true

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.demo_1_vpc.private_subnets
      security_group_ids  = [aws_security_group.demo_1_sg.id]
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.demo_1_vpc.private_subnets
      security_group_ids  = [aws_security_group.demo_1_sg.id]
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.demo_1_vpc.private_subnets
      security_group_ids  = [aws_security_group.demo_1_sg.id]
    },
  }

  tags = merge(local.endpoint_tags, {
    Endpoint = "true"
  })
}

module "demo_2_endpoints" {
  source = "./modules/vpc/modules/endpoints/"

  vpc_id             = module.demo_2_vpc.vpc_id
  security_group_ids = [data.aws_security_group.demo_2_default.id]
  create = true

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.demo_2_vpc.private_subnets
      security_group_ids  = [aws_security_group.demo_2_sg.id]
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.demo_2_vpc.private_subnets
      security_group_ids  = [aws_security_group.demo_2_sg.id]
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.demo_2_vpc.private_subnets
      security_group_ids  = [aws_security_group.demo_2_sg.id]
    },
  }

  tags = merge(local.endpoint_tags, {
    Endpoint = "true"
  })
}

################################################################################
# Supporting Resources
################################################################################

# TODO: add loop for these to clean it up
data "aws_security_group" "demo_1_default" {
  name   = "default"
  vpc_id = module.demo_1_vpc.vpc_id
}

data "aws_security_group" "demo_2_default" {
  name   = "default"
  vpc_id = module.demo_2_vpc.vpc_id
}

#############################################################################

# TODO: add loop for these to clean it up
resource "aws_security_group" "demo_1_sg" {
  name_prefix = "ssm_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.demo_1_vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.demo_1_vpc.vpc_cidr_block]
  }

  tags = local.endpoint_tags
}

resource "aws_security_group" "demo_2_sg" {
  name_prefix = "ssm_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.demo_2_vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.demo_2_vpc.vpc_cidr_block]
  }

  tags = local.endpoint_tags
}