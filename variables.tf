# Workspace Variables
locals {
  region_shorthand = join("", regex("^(..)-(..).*-([0-9])$", var.region))
  only_in_production_mapping = {
    aws-baseline-tf-usw2-network-dev = 0
    aws-baseline-tf-usw2-network-prd = 1
  }

  only_in_production = "${local.only_in_production_mapping[terraform.workspace]}"

  default_tags = {
    "AWS_2.0"      = true
    "map-migrated" = "d-server-003tca6ek6fl42"
  }
}

#####
# Provider Vars
#####
variable "access_key" {
  description = "AWS Access Key"
  type        = string
  default     = null
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = null
}

variable "role_arn" {
  description = "AWS Role ARN to Assume"
  type        = string
  default     = null
}

variable "external_id" {
  description = "AWS Role ID"
  type        = string
  default     = null
}
