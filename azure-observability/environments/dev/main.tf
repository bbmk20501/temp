module "observability" {
  source = "../../"

  environment         = "dev"
  location            = "eastus2"
  resource_group_name = "rg-observability-dev"

  tags = {
    project = "platform-observability"
    owner   = "platform-engineering"
  }

  # Log Analytics
  log_analytics_retention_days = 30
  log_analytics_daily_quota_gb = 5

  # Application Insights
  application_insights_configs = {
    "api" = {
      application_type    = "web"
      sampling_percentage = 50
    }
  }

  # Alerts
  alert_email_receivers = [
    {
      name          = "dev-team"
      email_address = "dev-team@example.com"
    }
  ]

  alert_webhook_receivers = []

  # Diagnostics
  monitored_resource_ids = []

  # Network
  enable_network_watcher  = false
  nsg_ids                 = {}
  flow_log_retention_days = 7
}
