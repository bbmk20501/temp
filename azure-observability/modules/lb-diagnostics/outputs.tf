output "diagnostic_setting_ids" {
  description = "Map of Load Balancer name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.lb : k => v.id }
}
