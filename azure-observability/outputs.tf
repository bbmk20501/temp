output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace"
  value       = module.log_analytics.workspace_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = module.log_analytics.workspace_name
}

output "log_analytics_primary_key" {
  description = "Primary shared key of the Log Analytics Workspace"
  value       = module.log_analytics.primary_shared_key
  sensitive   = true
}

output "application_insights" {
  description = "Map of Application Insights instance details"
  value = {
    for k, v in module.application_insights : k => {
      id                  = v.id
      instrumentation_key = v.instrumentation_key
      connection_string   = v.connection_string
    }
  }
  sensitive = true
}

output "critical_action_group_id" {
  description = "Resource ID of the critical-severity action group"
  value       = module.action_groups.critical_action_group_id
}

output "warning_action_group_id" {
  description = "Resource ID of the warning-severity action group"
  value       = module.action_groups.warning_action_group_id
}
