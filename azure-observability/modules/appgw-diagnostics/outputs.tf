output "diagnostic_setting_ids" {
  description = "Map of App Gateway name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.appgw : k => v.id }
}
