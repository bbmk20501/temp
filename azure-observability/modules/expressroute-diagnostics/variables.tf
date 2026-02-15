variable "expressroute_circuit_ids" {
  description = "Map of ExpressRoute circuit name to resource ID"
  type        = map(string)
  default     = {}
}

variable "expressroute_gateway_ids" {
  description = "Map of ExpressRoute gateway name to resource ID"
  type        = map(string)
  default     = {}
}

variable "workspace_id" {
  description = "Resource ID of the destination Log Analytics Workspace"
  type        = string
}
