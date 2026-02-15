locals {
  name_prefix = "observability-${var.environment}"
  common_tags = merge(var.tags, {
    environment = var.environment
    managed_by  = "terraform"
    component   = "platform-observability"
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
# Application Insights — APM for applications
# -------------------------------------------------------
module "application_insights" {
  source   = "./modules/application-insights"
  for_each = var.application_insights_configs

  name                = "appi-${local.name_prefix}-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = each.value.application_type
  workspace_id        = module.log_analytics.workspace_id
  sampling_percentage = each.value.sampling_percentage
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
# Alert Rules — platform health alerts
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
# Diagnostic Settings — route resource logs to workspace
# -------------------------------------------------------
module "diagnostic_settings" {
  source   = "./modules/diagnostic-settings"
  for_each = toset(var.monitored_resource_ids)

  target_resource_id = each.value
  workspace_id       = module.log_analytics.workspace_id
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
# Network Watcher — network diagnostics & flow logs
# -------------------------------------------------------
module "network_watcher" {
  source = "./modules/network-watcher"
  count  = var.enable_network_watcher ? 1 : 0

  name_prefix            = local.name_prefix
  resource_group_name    = var.resource_group_name
  location               = var.location
  workspace_id           = module.log_analytics.workspace_id
  nsg_ids                = var.nsg_ids
  flow_log_retention_days = var.flow_log_retention_days
  tags                   = local.common_tags
}
