resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "diag-to-law"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.workspace_id

  # Send all available log categories
  enabled_log {
    category_group = "allLogs"
  }

  # Send all metrics
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
