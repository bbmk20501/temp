variable "lb_resource_ids" {
  description = "Map of Load Balancer name to resource ID"
  type        = map(string)
}

variable "workspace_id" {
  description = "Resource ID of the destination Log Analytics Workspace"
  type        = string
}
