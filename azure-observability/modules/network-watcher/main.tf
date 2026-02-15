# Storage account for flow logs
resource "azurerm_storage_account" "flow_logs" {
  name                     = replace("st${var.name_prefix}flow", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

# NSG Flow Logs
resource "azurerm_network_watcher_flow_log" "this" {
  for_each = var.nsg_ids

  network_watcher_name = "NetworkWatcher_${var.location}"
  resource_group_name  = "NetworkWatcherRG"
  name                 = "flowlog-${each.key}"

  network_security_group_id = each.value
  storage_account_id        = azurerm_storage_account.flow_logs.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.this.workspace_id
    workspace_region      = var.location
    workspace_resource_id = var.workspace_id
    interval_in_minutes   = 10
  }

  tags = var.tags
}

data "azurerm_log_analytics_workspace" "this" {
  name                = split("/", var.workspace_id)[8]
  resource_group_name = split("/", var.workspace_id)[4]
}
