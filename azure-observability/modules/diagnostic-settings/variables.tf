variable "target_resource_id" {
  description = "Resource ID of the Azure resource to enable diagnostics on"
  type        = string
}

variable "workspace_id" {
  description = "Resource ID of the destination Log Analytics Workspace"
  type        = string
}
