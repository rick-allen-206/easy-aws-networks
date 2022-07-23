#######
# Backend
#######
terraform {
  required_version = "~> 1.1.3"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "example-org"
    workspaces {
      prefix = "example-"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
  }
}

#######
# Providers
#######
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  
  assume_role {
    role_arn    = var.role_arn
    external_id = var.external_id
  }

  default_tags {
    tags = local.only_in_production == 1 ? {
      "AWS"      = true
    } : {
      "AWS"      = true
    }
  }
}
