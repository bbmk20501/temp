module "observability" {
  source = "../../"

  environment         = "staging"
  location            = "eastus2"
  resource_group_name = "rg-observability-staging"

  tags = {
    project = "network-observability"
    owner   = "platform-engineering"
  }

  # Log Analytics
  log_analytics_retention_days = 60
  log_analytics_daily_quota_gb = 10

  # Alerts
  alert_email_receivers = [
    {
      name          = "platform-team"
      email_address = "platform-team@example.com"
    }
  ]

  alert_webhook_receivers = []

  # Azure Firewall
  firewall_resource_ids = {
    # "staging-firewall" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/azureFirewalls/<name>"
  }

  # Application Gateway
  appgw_resource_ids = {
    # "staging-appgw" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/applicationGateways/<name>"
  }

  # Load Balancer
  lb_resource_ids = {
    # "staging-lb" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/loadBalancers/<name>"
  }

  # DNS
  dns_public_zone_ids  = {}
  dns_private_zone_ids = {}
  dns_resolver_ids     = {}

  # ExpressRoute
  expressroute_circuit_ids = {}
  expressroute_gateway_ids = {}

  # Network Watcher
  enable_network_watcher  = false
  nsg_ids                 = {}
  flow_log_retention_days = 14

  # Catch-all
  monitored_resource_ids = []
}
