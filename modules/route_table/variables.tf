variable "route_table_name" {
  description = "Name of the route table"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "routes" {
  description = "Map of routes"
  type        = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
