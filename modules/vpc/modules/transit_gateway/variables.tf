
variable "tgw_name" {
  type        = string
  description = "Name of the TGW resource"
}

variable "tags" {
  type        = map(string)
  description = "Default tags to assign to the TGW and it's attachments"
  default     = {}
}
variable "tgw_tags" {
  type        = map(string)
  description = "Tags to assign to the TGW and it's attachments."
  default     = {}
}

variable "region" {
  type        = string
  description = "Region tgw should reside in"
}

variable "tgw_asn" {
  type        = string
  description = "(Optional) Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is `64512` to `65534` for 16-bit ASNs and `4200000000` to `4294967294` for 32-bit ASNs. Default value: `64512`."
  default     = null
}

variable "auto_accept_shared_attachments" {
  type        = string
  description = "Automatically accept attachments to the TGW"
  default     = "disable"
}

variable "dns_support" {
  type        = string
  description = "Enable DNS resolution of AWS internal names over Transit Gateway"
  default     = "enable"
}

variable "route_table_sets" {
  type = list(object({
    name           = string
    vpc_id         = string
    subnet_ids     = list(string)
    rt_association = string
    appliance_mode = string
    # attachment_tags = map(string)
  }))
  description = "A list of VPCs to build transit gatways resources for as well as what route table set they should belong to. rt_association should be the name of the route table to assciate to, if the route table specified doesn't exist it will be created."
}

