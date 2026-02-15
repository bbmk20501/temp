module "observability" {
  source = "../../"

  environment         = "staging"
  location            = "eastus2"
  resource_group_name = "rg-observability-staging"

  tags = {
    project = "platform-observability"
    owner   = "platform-engineering"
  }

  # Log Analytics
  log_analytics_retention_days = 60
  log_analytics_daily_quota_gb = 10

  # Application Insights
  application_insights_configs = {
    "api" = {
      application_type    = "web"
      sampling_percentage = 75
    }
    "frontend" = {
      application_type    = "web"
      sampling_percentage = 50
    }
  }

  # Alerts
  alert_email_receivers = [
    {
      name          = "platform-team"
      email_address = "platform-team@example.com"
    }
  ]

  alert_webhook_receivers = []

  # Diagnostics
  monitored_resource_ids = []

  # Network
  enable_network_watcher  = false
  nsg_ids                 = {}
  flow_log_retention_days = 14
}
