variable "name" {
  description = "Name of the Application Insights instance"
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

variable "application_type" {
  description = "Type of application (web, java, ios, phone, store, other)"
  type        = string
  default     = "web"
}

variable "workspace_id" {
  description = "Log Analytics Workspace resource ID for workspace-based mode"
  type        = string
}

variable "sampling_percentage" {
  description = "Percentage of telemetry to ingest (0-100)"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
