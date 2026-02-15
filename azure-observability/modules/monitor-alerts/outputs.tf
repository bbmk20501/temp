output "alert_rule_ids" {
  description = "Map of alert rule names to their resource IDs"
  value = {
    heartbeat_missing = azurerm_monitor_scheduled_query_rules_alert_v2.heartbeat_missing.id
    high_cpu          = azurerm_monitor_scheduled_query_rules_alert_v2.high_cpu.id
    low_disk          = azurerm_monitor_scheduled_query_rules_alert_v2.low_disk.id
    high_memory       = azurerm_monitor_scheduled_query_rules_alert_v2.high_memory.id
    brute_force       = azurerm_monitor_scheduled_query_rules_alert_v2.brute_force.id
  }
}
