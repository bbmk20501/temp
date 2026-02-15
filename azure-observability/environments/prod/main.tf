module "observability" {
  source = "../../"

  environment         = "prod"
  location            = "eastus2"
  resource_group_name = "rg-observability-prod"

  tags = {
    project = "platform-observability"
    owner   = "platform-engineering"
  }

  # Log Analytics — extended retention, no quota
  log_analytics_retention_days = 180
  log_analytics_daily_quota_gb = -1

  # Application Insights
  application_insights_configs = {
    "api" = {
      application_type    = "web"
      sampling_percentage = 100
    }
    "frontend" = {
      application_type    = "web"
      sampling_percentage = 50
    }
    "worker" = {
      application_type    = "web"
      sampling_percentage = 100
    }
  }

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

  # Diagnostics — add production resource IDs here
  monitored_resource_ids = []

  # Network — enable flow logs in production
  enable_network_watcher  = true
  nsg_ids                 = {}
  flow_log_retention_days = 90
}
