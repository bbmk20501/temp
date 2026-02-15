variable "name_prefix" {
  description = "Prefix for alert rule names"
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

variable "log_analytics_id" {
  description = "Resource ID of the Log Analytics Workspace to query"
  type        = string
}

variable "action_group_id" {
  description = "Action group ID for critical alerts"
  type        = string
}

variable "warn_action_group_id" {
  description = "Action group ID for warning alerts"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
