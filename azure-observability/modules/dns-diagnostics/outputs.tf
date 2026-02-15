output "public_zone_diagnostic_ids" {
  description = "Map of public DNS zone name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.dns_public : k => v.id }
}

output "private_zone_diagnostic_ids" {
  description = "Map of private DNS zone name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.dns_private : k => v.id }
}

output "resolver_diagnostic_ids" {
  description = "Map of DNS Resolver name to diagnostic setting resource ID"
  value       = { for k, v in azurerm_monitor_diagnostic_setting.dns_resolver : k => v.id }
}
