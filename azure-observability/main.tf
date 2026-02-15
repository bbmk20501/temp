locals {
  name_prefix = "observability-${var.environment}"
  common_tags = merge(var.tags, {
    environment = var.environment
    managed_by  = "terraform"
    component   = "network-observability"
  })
}

# -------------------------------------------------------
# Log Analytics Workspace — central log sink
# -------------------------------------------------------
module "log_analytics" {
  source = "./modules/log-analytics"

  name                = "law-${local.name_prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days
  daily_quota_gb      = var.log_analytics_daily_quota_gb
  tags                = local.common_tags
}

# -------------------------------------------------------
# Action Groups — notification routing
# -------------------------------------------------------
module "action_groups" {
  source = "./modules/action-groups"

  name_prefix         = local.name_prefix
  resource_group_name = var.resource_group_name
  email_receivers     = var.alert_email_receivers
  webhook_receivers   = var.alert_webhook_receivers
  tags                = local.common_tags
}

# -------------------------------------------------------
# Alert Rules — networking health alerts
# -------------------------------------------------------
module "monitor_alerts" {
  source = "./modules/monitor-alerts"

  name_prefix          = local.name_prefix
  resource_group_name  = var.resource_group_name
  location             = var.location
  log_analytics_id     = module.log_analytics.workspace_id
  action_group_id      = module.action_groups.critical_action_group_id
  warn_action_group_id = module.action_groups.warning_action_group_id
  tags                 = local.common_tags
}

# -------------------------------------------------------
# Azure Firewall Diagnostics
# -------------------------------------------------------
module "firewall_diagnostics" {
  source = "./modules/firewall-diagnostics"
  count  = length(var.firewall_resource_ids) > 0 ? 1 : 0

  firewall_resource_ids = var.firewall_resource_ids
  workspace_id          = module.log_analytics.workspace_id
}

# -------------------------------------------------------
# Application Gateway Diagnostics
# -------------------------------------------------------
module "appgw_diagnostics" {
  source = "./modules/appgw-diagnostics"
  count  = length(var.appgw_resource_ids) > 0 ? 1 : 0

  appgw_resource_ids = var.appgw_resource_ids
  workspace_id       = module.log_analytics.workspace_id
}

# -------------------------------------------------------
# Load Balancer Diagnostics
# -------------------------------------------------------
module "lb_diagnostics" {
  source = "./modules/lb-diagnostics"
  count  = length(var.lb_resource_ids) > 0 ? 1 : 0

  lb_resource_ids = var.lb_resource_ids
  workspace_id    = module.log_analytics.workspace_id
}

# -------------------------------------------------------
# DNS Diagnostics (Public + Private Zones + Resolver)
# -------------------------------------------------------
module "dns_diagnostics" {
  source = "./modules/dns-diagnostics"
  count  = (length(var.dns_public_zone_ids) + length(var.dns_private_zone_ids) + length(var.dns_resolver_ids)) > 0 ? 1 : 0

  dns_public_zone_ids  = var.dns_public_zone_ids
  dns_private_zone_ids = var.dns_private_zone_ids
  dns_resolver_ids     = var.dns_resolver_ids
  workspace_id         = module.log_analytics.workspace_id
}

# -------------------------------------------------------
# ExpressRoute Diagnostics (Circuits + Gateways)
# -------------------------------------------------------
module "expressroute_diagnostics" {
  source = "./modules/expressroute-diagnostics"
  count  = (length(var.expressroute_circuit_ids) + length(var.expressroute_gateway_ids)) > 0 ? 1 : 0

  expressroute_circuit_ids = var.expressroute_circuit_ids
  expressroute_gateway_ids = var.expressroute_gateway_ids
  workspace_id             = module.log_analytics.workspace_id
}

# -------------------------------------------------------
# Network Watcher — NSG flow logs & traffic analytics
# -------------------------------------------------------
module "network_watcher" {
  source = "./modules/network-watcher"
  count  = var.enable_network_watcher ? 1 : 0

  name_prefix             = local.name_prefix
  resource_group_name     = var.resource_group_name
  location                = var.location
  workspace_id            = module.log_analytics.workspace_id
  nsg_ids                 = var.nsg_ids
  flow_log_retention_days = var.flow_log_retention_days
  tags                    = local.common_tags
}

# -------------------------------------------------------
# Dashboards — Azure portal dashboards
# -------------------------------------------------------
module "dashboards" {
  source = "./modules/dashboards"

  name_prefix         = local.name_prefix
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = module.log_analytics.workspace_id
  tags                = local.common_tags
}

# -------------------------------------------------------
# Generic Diagnostic Settings — catch-all for other resources
# -------------------------------------------------------
module "diagnostic_settings" {
  source   = "./modules/diagnostic-settings"
  for_each = toset(var.monitored_resource_ids)

  target_resource_id = each.value
  workspace_id       = module.log_analytics.workspace_id
}
