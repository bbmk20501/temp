# =============================================================
# Azure Firewall Alerts
# =============================================================

# --- Firewall SNAT port exhaustion (>90% utilization) ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "firewall_snat_exhaustion" {
  name                = "alert-${var.name_prefix}-fw-snat-exhaustion"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Azure Firewall SNAT port utilization exceeded 90%"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName == "SNATPortUtilization"
      | where Maximum > 90
      | project TimeGenerated, Resource, Maximum
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}

# --- Firewall health degraded (<100%) ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "firewall_health_degraded" {
  name                = "alert-${var.name_prefix}-fw-health-degraded"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Azure Firewall health state dropped below 100%"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName == "FirewallHealth"
      | where Average < 100
      | project TimeGenerated, Resource, Average
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}

# --- Firewall Threat Intel hit detected ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "firewall_threat_intel" {
  name                = "alert-${var.name_prefix}-fw-threat-intel"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Azure Firewall Threat Intelligence triggered — known malicious IP/FQDN detected"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT10M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AZFWThreatIntel
      | project TimeGenerated, SourceIp, DestinationIp, DestinationPort, ThreatDescription, Action
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}

# =============================================================
# Application Gateway Alerts
# =============================================================

# --- App Gateway backend unhealthy hosts ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "appgw_unhealthy_backend" {
  name                = "alert-${var.name_prefix}-appgw-unhealthy-backend"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Application Gateway has unhealthy backend hosts"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName == "UnhealthyHostCount"
      | where Maximum > 0
      | project TimeGenerated, Resource, Maximum
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 2
      number_of_evaluation_periods             = 3
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}

# --- App Gateway high 5xx error rate ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "appgw_5xx_errors" {
  name                = "alert-${var.name_prefix}-appgw-5xx-errors"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Application Gateway 5xx error rate exceeds threshold"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureDiagnostics
      | where ResourceType == "APPLICATIONGATEWAYS"
      | where Category == "ApplicationGatewayAccessLog"
      | summarize
          TotalRequests = count(),
          ServerErrors  = countif(httpStatus_d >= 500)
          by Resource, bin(TimeGenerated, 5m)
      | where TotalRequests > 10
      | extend ErrorRatePct = ServerErrors * 100.0 / TotalRequests
      | where ErrorRatePct > 5
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.warn_action_group_id]
  }
}

# --- WAF blocked requests spike ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "appgw_waf_blocked_spike" {
  name                = "alert-${var.name_prefix}-appgw-waf-blocked"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "WAF blocked more than 100 requests in 10 minutes — possible attack"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT10M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureDiagnostics
      | where ResourceType == "APPLICATIONGATEWAYS"
      | where Category == "ApplicationGatewayFirewallLog"
      | where action_s == "Blocked"
      | summarize BlockedCount = count() by Resource, bin(TimeGenerated, 10m)
      | where BlockedCount > 100
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.warn_action_group_id]
  }
}

# =============================================================
# Load Balancer Alerts
# =============================================================

# --- Load Balancer health probe degraded ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "lb_health_degraded" {
  name                = "alert-${var.name_prefix}-lb-health-degraded"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Load Balancer backend health probe availability dropped below 100%"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName == "DipAvailability"
      | where Average < 100
      | project TimeGenerated, Resource, Average
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 2
      number_of_evaluation_periods             = 3
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}

# --- LB SNAT port exhaustion ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "lb_snat_exhaustion" {
  name                = "alert-${var.name_prefix}-lb-snat-exhaustion"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Load Balancer SNAT port usage exceeded 80% of allocated ports"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName in ("AllocatedSnatPorts", "UsedSnatPorts")
      | summarize AvgValue = avg(Average) by Resource, MetricName, bin(TimeGenerated, 5m)
      | evaluate pivot(MetricName, take_any(AvgValue))
      | where AllocatedSnatPorts > 0
      | extend UsedPct = UsedSnatPorts * 100.0 / AllocatedSnatPorts
      | where UsedPct > 80
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.warn_action_group_id]
  }
}

# =============================================================
# ExpressRoute Alerts
# =============================================================

# --- ExpressRoute ARP availability drop ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "expressroute_arp_drop" {
  name                = "alert-${var.name_prefix}-er-arp-drop"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "ExpressRoute circuit ARP availability dropped below 99.9%"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName == "ArpAvailability"
      | where Average < 99.9
      | project TimeGenerated, Resource, Average
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}

# --- ExpressRoute BGP availability drop ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "expressroute_bgp_drop" {
  name                = "alert-${var.name_prefix}-er-bgp-drop"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "ExpressRoute circuit BGP availability dropped below 99.9%"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName == "BgpAvailability"
      | where Average < 99.9
      | project TimeGenerated, Resource, Average
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.action_group_id]
  }
}

# --- ExpressRoute Gateway high CPU ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "expressroute_gw_cpu" {
  name                = "alert-${var.name_prefix}-er-gw-high-cpu"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "ExpressRoute Gateway CPU utilization exceeded 80% — consider scaling"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AzureMetrics
      | where ResourceProvider == "MICROSOFT.NETWORK"
      | where MetricName == "ExpressRouteGatewayCpuUtilization"
      | where Average > 80
      | project TimeGenerated, Resource, Average
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 2
      number_of_evaluation_periods             = 3
    }
  }

  action {
    action_groups = [var.warn_action_group_id]
  }
}

# =============================================================
# DNS Alerts
# =============================================================

# --- High DNS query failure rate ---
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "dns_query_failures" {
  name                = "alert-${var.name_prefix}-dns-failures"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "DNS query failure rate is elevated — NXDOMAIN or SERVFAIL responses detected"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                = [var.log_analytics_id]
  evaluation_frequency  = "PT5M"
  window_duration       = "PT15M"
  target_resource_types = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      AZFWDnsQuery
      | where ResponseCode != "NOERROR"
      | summarize FailureCount = count() by ResponseCode, bin(TimeGenerated, 5m)
      | where FailureCount > 50
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [var.warn_action_group_id]
  }
}
