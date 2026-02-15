output "flow_log_ids" {
  description = "Map of NSG name to flow log resource ID"
  value       = { for k, v in azurerm_network_watcher_flow_log.this : k => v.id }
}

output "flow_log_storage_account_id" {
  description = "Resource ID of the storage account for flow logs"
  value       = azurerm_storage_account.flow_logs.id
}
