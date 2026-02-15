variable "firewall_resource_ids" {
  description = "Map of firewall name to Azure Firewall resource ID"
  type        = map(string)
}

variable "workspace_id" {
  description = "Resource ID of the destination Log Analytics Workspace"
  type        = string
}
