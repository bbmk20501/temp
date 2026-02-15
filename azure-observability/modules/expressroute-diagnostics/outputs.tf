output "circuit_diagnostic_ids" {
  description = "Map of ExpressRoute circuit name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.expressroute_circuit : k => v.id }
}

output "gateway_diagnostic_ids" {
  description = "Map of ExpressRoute gateway name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.expressroute_gateway : k => v.id }
}
