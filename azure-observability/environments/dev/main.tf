module "observability" {
  source = "../../"

  environment         = "dev"
  location            = "eastus2"
  resource_group_name = "rg-observability-dev"

  tags = {
    project = "network-observability"
    owner   = "platform-engineering"
  }

  # Log Analytics
  log_analytics_retention_days = 30
  log_analytics_daily_quota_gb = 5

  # Alerts
  alert_email_receivers = [
    {
      name          = "dev-team"
      email_address = "dev-team@example.com"
    }
  ]

  alert_webhook_receivers = []

  # Azure Firewall
  firewall_resource_ids = {
    # "dev-firewall" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/azureFirewalls/<name>"
  }

  # Application Gateway
  appgw_resource_ids = {
    # "dev-appgw" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/applicationGateways/<name>"
  }

  # Load Balancer
  lb_resource_ids = {
    # "dev-lb" = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/loadBalancers/<name>"
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
  flow_log_retention_days = 7

  # Catch-all
  monitored_resource_ids = []
}
