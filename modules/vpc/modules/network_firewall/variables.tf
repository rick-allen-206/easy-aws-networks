variable "region" {
  description = "Region"
  type        = string
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Default tags to assign to ANF and all of it's endpoints"
  default = {}
}

variable "firewall_name" {
  description = "Firewall Name"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID of the VPC in which to create the firewall."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Region"
  type        = list(string)
  default     = null
}

variable "stateless_default_actions" {
  description = "Default stateless Action."
  type        = string
  default     = "drop"
}

variable "stateless_fragment_default_actions" {
  description = "Default Stateless action for fragmented packets"
  type        = string
  default     = "drop"
}

variable "stateful_rule_order" {
  description = "Stateful rule order."
  type        = string
  default     = "STRICT_ORDER"
}

variable "stateful_default_actions" {
  description = "Default stateful Action."
  type        = string
  default     = "drop_strict"
}

variable "fivetuple_stateful_rule_group" {
  description = "Config for 5-tuple type stateful rule group."
  type = list(object({
    capacity    = number
    name        = string
    description = string
    rule_config = list(object({
      protocol              = string
      source_ipaddress      = string
      source_port           = any
      destination_ipaddress = string
      destination_port      = any
      direction             = string
      actions = object({
        type = string
      })
    }))
  }))
  default = []
}

variable "domain_stateful_rule_group" {
  description = "Config for domain type stateful rule group."
  type        = list(any)
  default     = []
}

variable "stateless_rule_group" {
  description = "Config for stateless rule group."
  type        = list(any)
  default     = []
}
