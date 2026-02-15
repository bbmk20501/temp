# Diagnostic settings for Azure Load Balancer → Log Analytics
resource "azurerm_monitor_diagnostic_setting" "lb" {
  for_each = var.lb_resource_ids

  name                       = "diag-${each.key}-to-law"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category = "LoadBalancerAlertEvent"
  }

  enabled_log {
    category = "LoadBalancerProbeHealthStatus"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
