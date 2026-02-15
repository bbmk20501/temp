# Diagnostic settings for ExpressRoute Circuits + Gateways → Log Analytics
resource "azurerm_monitor_diagnostic_setting" "expressroute_circuit" {
  for_each = var.expressroute_circuit_ids

  name                       = "diag-${each.key}-to-law"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category = "PeeringRouteLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "expressroute_gateway" {
  for_each = var.expressroute_gateway_ids

  name                       = "diag-${each.key}-to-law"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
