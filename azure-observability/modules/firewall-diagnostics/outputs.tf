output "diagnostic_setting_ids" {
  description = "Map of firewall name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.firewall : k => v.id }
}
