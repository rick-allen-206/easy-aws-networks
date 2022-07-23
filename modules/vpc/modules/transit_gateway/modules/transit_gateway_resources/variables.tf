variable "region" {
  description = "Region for all resources"
  type        = string
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Default tags and tgw tags to add to attachments"
  default     = {}
}

variable "rt_name" {
  description = "Name for the Route Table"
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  type        = string
  default     = null
}

variable "rt_details" {
  description = "A list of values to iterate over to create attachments, route table, and associations"
  type = list(object({
    name           = string
    vpc_id         = string
    subnet_ids     = list(string)
    rt_association = string
    appliance_mode = string
    # tags           = map(string)
  }))
  default = null
}
