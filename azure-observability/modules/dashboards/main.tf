resource "azurerm_portal_dashboard" "platform_overview" {
  name                = "dash-${var.name_prefix}-platform-overview"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dashboard_properties = templatefile("${path.module}/templates/platform-overview.tpl.json", {
    workspace_id = var.workspace_id
  })
}
