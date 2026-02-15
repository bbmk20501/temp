output "critical_action_group_id" {
  description = "Resource ID of the critical action group"
  value       = azurerm_monitor_action_group.critical.id
}

output "warning_action_group_id" {
  description = "Resource ID of the warning action group"
  value       = azurerm_monitor_action_group.warning.id
}

output "informational_action_group_id" {
  description = "Resource ID of the informational action group"
  value       = azurerm_monitor_action_group.informational.id
}
