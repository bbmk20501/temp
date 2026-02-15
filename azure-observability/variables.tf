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

# =============================================================
# Log Analytics
# =============================================================

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

# =============================================================
# Alert notification
# =============================================================

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

# =============================================================
# Azure Firewall
# =============================================================

variable "firewall_resource_ids" {
  description = "Map of Azure Firewall name to resource ID for diagnostic settings"
  type        = map(string)
  default     = {}
}

# =============================================================
# Application Gateway
# =============================================================

variable "appgw_resource_ids" {
  description = "Map of Application Gateway name to resource ID for diagnostic settings"
  type        = map(string)
  default     = {}
}

# =============================================================
# Load Balancer
# =============================================================

variable "lb_resource_ids" {
  description = "Map of Load Balancer name to resource ID for diagnostic settings"
  type        = map(string)
  default     = {}
}

# =============================================================
# DNS
# =============================================================

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

# =============================================================
# ExpressRoute
# =============================================================

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

# =============================================================
# Network Watcher / NSG Flow Logs
# =============================================================

variable "enable_network_watcher" {
  description = "Whether to enable Network Watcher NSG flow logs and traffic analytics"
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

# =============================================================
# Generic catch-all diagnostics
# =============================================================

variable "monitored_resource_ids" {
  description = "List of additional Azure resource IDs to enable diagnostic settings on"
  type        = list(string)
  default     = []
}
