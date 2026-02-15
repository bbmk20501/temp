variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the resource group for observability resources"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

# Log Analytics
variable "log_analytics_sku" {
  description = "SKU for the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_days" {
  description = "Data retention in days for the Log Analytics Workspace"
  type        = number
  default     = 90
}

variable "log_analytics_daily_quota_gb" {
  description = "Daily ingestion quota in GB (-1 for unlimited)"
  type        = number
  default     = -1
}

# Application Insights
variable "application_insights_configs" {
  description = "Map of Application Insights instances to create"
  type = map(object({
    application_type = string
    sampling_percentage = optional(number, 100)
  }))
  default = {}
}

# Alert notification
variable "alert_email_receivers" {
  description = "List of email addresses for alert notifications"
  type = list(object({
    name          = string
    email_address = string
  }))
  default = []
}

variable "alert_webhook_receivers" {
  description = "List of webhook endpoints for alert notifications"
  type = list(object({
    name        = string
    service_uri = string
  }))
  default = []
}

# Monitored resources
variable "monitored_resource_ids" {
  description = "List of Azure resource IDs to enable diagnostic settings on"
  type        = list(string)
  default     = []
}

# Network Watcher
variable "enable_network_watcher" {
  description = "Whether to enable Network Watcher and NSG flow logs"
  type        = bool
  default     = false
}

variable "nsg_ids" {
  description = "Map of NSG name to resource ID for flow log enablement"
  type        = map(string)
  default     = {}
}

variable "flow_log_retention_days" {
  description = "Retention in days for NSG flow logs"
  type        = number
  default     = 30
}
