module "observability" {
  source = "../../"

  environment         = "prod"
  location            = "eastus2"
  resource_group_name = "rg-observability-prod"

  tags = {
    project = "network-observability"
    owner   = "platform-engineering"
  }

  # Log Analytics — extended retention, no quota
  log_analytics_retention_days = 180
  log_analytics_daily_quota_gb = -1

  # Alerts
  alert_email_receivers = [
    {
      name          = "platform-team"
      email_address = "platform-team@example.com"
    },
    {
      name          = "oncall"
      email_address = "oncall@example.com"
    }
  ]

  alert_webhook_receivers = [
    # {
    #   name        = "pagerduty"
    #   service_uri = "https://events.pagerduty.com/integration/<key>/enqueue"
    # }
  ]

  # Azure Firewall
  firewall_resource_ids = {
    # "hub-firewall" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/azureFirewalls/<name>"
  }

  # Application Gateway
  appgw_resource_ids = {
    # "prod-appgw" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/applicationGateways/<name>"
  }

  # Load Balancer
  lb_resource_ids = {
    # "prod-internal-lb" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/loadBalancers/<name>"
    # "prod-external-lb" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/loadBalancers/<name>"
  }

  # DNS
  dns_public_zone_ids = {
    # "example-com" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/dnsZones/example.com"
  }

  dns_private_zone_ids = {
    # "internal" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/privateDnsZones/internal.example.com"
  }

  dns_resolver_ids = {
    # "hub-resolver" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/dnsResolvers/<name>"
  }

  # ExpressRoute
  expressroute_circuit_ids = {
    # "primary-circuit" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/expressRouteCircuits/<name>"
  }

  expressroute_gateway_ids = {
    # "hub-ergw" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworkGateways/<name>"
  }

  # Network Watcher — enable flow logs in production
  enable_network_watcher  = true
  nsg_ids                 = {}
  flow_log_retention_days = 90

  # Catch-all
  monitored_resource_ids = []
}
