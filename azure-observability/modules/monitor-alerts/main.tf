# -------------------------------------------------------
# Heartbeat — detect agents that stopped reporting
# -------------------------------------------------------
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "heartbeat_missing" {
  name                = "alert-${var.name_prefix}-heartbeat-missing"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "One or more monitored resources stopped sending heartbeats"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                    = [var.log_analytics_id]
  evaluation_frequency      = "PT5M"
  window_duration           = "PT15M"
  target_resource_types     = ["Microsoft.OperationalInsights/workspaces"]
  skip_query_validation     = false

  criteria {
    query = <<-KQL
      Heartbeat
      | summarize LastHeartbeat = max(TimeGenerated) by Computer
      | where LastHeartbeat < ago(10m)
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

# -------------------------------------------------------
# High CPU — log-based alert via Perf table
# -------------------------------------------------------
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "high_cpu" {
  name                = "alert-${var.name_prefix}-high-cpu"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Average CPU utilization exceeded 90% over the last 15 minutes"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                    = [var.log_analytics_id]
  evaluation_frequency      = "PT5M"
  window_duration           = "PT15M"
  target_resource_types     = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      Perf
      | where ObjectName == "Processor" and CounterName == "% Processor Time" and InstanceName == "_Total"
      | summarize AvgCPU = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
      | where AvgCPU > 90
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

# -------------------------------------------------------
# Low Disk Space — less than 10% free
# -------------------------------------------------------
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "low_disk" {
  name                = "alert-${var.name_prefix}-low-disk"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Disk free space dropped below 10%"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                    = [var.log_analytics_id]
  evaluation_frequency      = "PT15M"
  window_duration           = "PT30M"
  target_resource_types     = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      Perf
      | where ObjectName == "LogicalDisk" and CounterName == "% Free Space"
      | where InstanceName != "_Total"
      | summarize MinFree = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)
      | where MinFree < 10
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

# -------------------------------------------------------
# High Memory Usage — over 90%
# -------------------------------------------------------
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "high_memory" {
  name                = "alert-${var.name_prefix}-high-memory"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Memory utilization exceeded 90%"
  severity            = 2
  enabled             = true
  tags                = var.tags

  scopes                    = [var.log_analytics_id]
  evaluation_frequency      = "PT5M"
  window_duration           = "PT15M"
  target_resource_types     = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      Perf
      | where ObjectName == "Memory" and CounterName == "% Committed Bytes In Use"
      | summarize AvgMem = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
      | where AvgMem > 90
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

# -------------------------------------------------------
# Security Events — brute force detection
# -------------------------------------------------------
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "brute_force" {
  name                = "alert-${var.name_prefix}-brute-force"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Possible brute force attack detected — more than 50 failed logins in 10 minutes"
  severity            = 1
  enabled             = true
  tags                = var.tags

  scopes                    = [var.log_analytics_id]
  evaluation_frequency      = "PT5M"
  window_duration           = "PT10M"
  target_resource_types     = ["Microsoft.OperationalInsights/workspaces"]

  criteria {
    query = <<-KQL
      SecurityEvent
      | where EventID == 4625
      | summarize FailedAttempts = count() by TargetAccount, IpAddress, bin(TimeGenerated, 10m)
      | where FailedAttempts > 50
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
