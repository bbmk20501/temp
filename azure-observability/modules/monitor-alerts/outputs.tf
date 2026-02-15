output "alert_rule_ids" {
  description = "Map of alert rule names to their resource IDs"
  value = {
    # Firewall
    firewall_snat_exhaustion = azurerm_monitor_scheduled_query_rules_alert_v2.firewall_snat_exhaustion.id
    firewall_health_degraded = azurerm_monitor_scheduled_query_rules_alert_v2.firewall_health_degraded.id
    firewall_threat_intel    = azurerm_monitor_scheduled_query_rules_alert_v2.firewall_threat_intel.id
    # App Gateway
    appgw_unhealthy_backend = azurerm_monitor_scheduled_query_rules_alert_v2.appgw_unhealthy_backend.id
    appgw_5xx_errors        = azurerm_monitor_scheduled_query_rules_alert_v2.appgw_5xx_errors.id
    appgw_waf_blocked       = azurerm_monitor_scheduled_query_rules_alert_v2.appgw_waf_blocked_spike.id
    # Load Balancer
    lb_health_degraded = azurerm_monitor_scheduled_query_rules_alert_v2.lb_health_degraded.id
    lb_snat_exhaustion = azurerm_monitor_scheduled_query_rules_alert_v2.lb_snat_exhaustion.id
    # ExpressRoute
    expressroute_arp_drop = azurerm_monitor_scheduled_query_rules_alert_v2.expressroute_arp_drop.id
    expressroute_bgp_drop = azurerm_monitor_scheduled_query_rules_alert_v2.expressroute_bgp_drop.id
    expressroute_gw_cpu   = azurerm_monitor_scheduled_query_rules_alert_v2.expressroute_gw_cpu.id
    # DNS
    dns_query_failures = azurerm_monitor_scheduled_query_rules_alert_v2.dns_query_failures.id
  }
}
