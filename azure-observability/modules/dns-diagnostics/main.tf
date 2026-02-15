# Diagnostic settings for Azure DNS (Private Zones + Public Zones) → Log Analytics
resource "azurerm_monitor_diagnostic_setting" "dns_public" {
  for_each = var.dns_public_zone_ids

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

resource "azurerm_monitor_diagnostic_setting" "dns_private" {
  for_each = var.dns_private_zone_ids

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

# DNS Private Resolver diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "dns_resolver" {
  for_each = var.dns_resolver_ids

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
