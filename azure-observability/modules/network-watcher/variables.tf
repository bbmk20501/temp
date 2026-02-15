variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "workspace_id" {
  description = "Resource ID of the Log Analytics Workspace for Traffic Analytics"
  type        = string
}

variable "nsg_ids" {
  description = "Map of NSG name to resource ID"
  type        = map(string)
  default     = {}
}

variable "flow_log_retention_days" {
  description = "Retention in days for flow logs in storage"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
