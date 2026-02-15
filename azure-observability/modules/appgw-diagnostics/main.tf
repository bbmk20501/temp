# Diagnostic settings for Application Gateway → Log Analytics
resource "azurerm_monitor_diagnostic_setting" "appgw" {
  for_each = var.appgw_resource_ids

  name                       = "diag-${each.key}-to-law"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
