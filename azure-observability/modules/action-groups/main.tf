# Critical severity — immediate response required
resource "azurerm_monitor_action_group" "critical" {
  name                = "ag-${var.name_prefix}-critical"
  resource_group_name = var.resource_group_name
  short_name          = "Critical"
  enabled             = true
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = true
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.webhook_receivers
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = true
    }
  }
}

# Warning severity — investigate within SLA
resource "azurerm_monitor_action_group" "warning" {
  name                = "ag-${var.name_prefix}-warning"
  resource_group_name = var.resource_group_name
  short_name          = "Warning"
  enabled             = true
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = true
    }
  }
}

# Informational — low priority notifications
resource "azurerm_monitor_action_group" "informational" {
  name                = "ag-${var.name_prefix}-info"
  resource_group_name = var.resource_group_name
  short_name          = "Info"
  enabled             = true
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = true
    }
  }
}
