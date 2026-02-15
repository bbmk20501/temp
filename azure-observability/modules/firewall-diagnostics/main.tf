# Diagnostic settings for Azure Firewall → Log Analytics
resource "azurerm_monitor_diagnostic_setting" "firewall" {
  for_each = var.firewall_resource_ids

  name                       = "diag-${each.key}-to-law"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  enabled_log {
    category = "AZFWThreatIntel"
  }

  enabled_log {
    category = "AZFWIdpsSignature"
  }

  enabled_log {
    category = "AZFWNatRule"
  }

  enabled_log {
    category = "AZFWFatFlow"
  }

  enabled_log {
    category = "AZFWFlowTrace"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
