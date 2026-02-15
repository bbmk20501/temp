variable "dns_public_zone_ids" {
  description = "Map of public DNS zone name to resource ID"
  type        = map(string)
  default     = {}
}

variable "dns_private_zone_ids" {
  description = "Map of private DNS zone name to resource ID"
  type        = map(string)
  default     = {}
}

variable "dns_resolver_ids" {
  description = "Map of DNS Private Resolver name to resource ID"
  type        = map(string)
  default     = {}
}

variable "workspace_id" {
  description = "Resource ID of the destination Log Analytics Workspace"
  type        = string
}
