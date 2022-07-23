variable "ram_name" {
  type        = string
  description = "Name for the RAM share"
  default     = null
}

variable "allow_external_principals" {
  type        = bool
  description = "(Optional) Indicates whether principals outside your organization can be associated with a resource share."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to resource shares."
  default     = {}
}

variable "resource_arns" {
  type        = list(string)
  description = "(Required) List of Amazon Resource Names (ARN) of the resources to associate with the RAM Resource Share."
  default     = null
}
