variable "region" {
  type        = string
  description = "region tgw should reside in"
}

variable "tags" {
  type        = map(string)
  description = "Default tags to apply to dxg and all of it's resources"
  default = {}
}

variable "dxg_asn" {
  type        = string
  description = "(Required) The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration."
  default     = null
}

variable "dxg_name" {
  type        = string
  description = "The name of the DXG"
  default     = null
}

variable "tgw_id" {
  type        = string
  description = "(Optional) The ID of the VGW or transit gateway with which to associate the Direct Connect gateway. Used for single account Direct Connect gateway associations."
  default     = null
}

variable "allowed_prefixes" {
  type        = list(string)
  description = "(Optional) VPC prefixes (CIDRs) to advertise to the Direct Connect gateway. Defaults to the CIDR block of the VPC associated with the Virtual Gateway. To enable drift detection, must be configured."
  default     = []
}

# variable "tgw_routes" {
#   type        = map(map(string))
#   description = "Map with cidr_block and tgw_attachment_id strings"
#   default     = {}
# }

variable "vif" {
  type = map(object({
    connection_id = string
    name          = string
    vlan          = number
    bgp_asn       = number
    bgp_auth_key  = string
  }))
  description = "(Required) Virtual interface information."
  default = {}
}
