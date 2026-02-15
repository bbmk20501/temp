# Azure Platform Observability

End-to-end observability for Azure Cloud Platform using **Azure-native tools only** — no third-party agents or SaaS platforms required.

## Architecture Overview

```
+------------------------------------------------------------------+
|                    Azure Platform Observability                    |
+------------------------------------------------------------------+
|                                                                    |
|  +-----------------+    +-------------------+    +--------------+  |
|  | Diagnostic      |--->| Log Analytics     |--->| Azure        |  |
|  | Settings        |    | Workspace         |    | Dashboards   |  |
|  +-----------------+    +-------------------+    +--------------+  |
|                                |                                   |
|  +-----------------+           |          +---------------------+  |
|  | Application     |-----------+--------->| Azure Monitor       |  |
|  | Insights        |           |          | Alerts & Action     |  |
|  +-----------------+           |          | Groups              |  |
|                                |          +---------------------+  |
|  +-----------------+           |                                   |
|  | Network         |-----------+                                   |
|  | Watcher         |                                               |
|  +-----------------+                                               |
|                                                                    |
+------------------------------------------------------------------+
```

## Azure-Native Services Used

| Service | Purpose |
|---------|---------|
| **Azure Monitor** | Central monitoring platform — metrics, logs, alerts |
| **Log Analytics Workspace** | Centralized log ingestion, retention, and KQL query engine |
| **Application Insights** | Application performance monitoring (APM) |
| **Diagnostic Settings** | Route platform logs and metrics from Azure resources to Log Analytics |
| **Azure Monitor Alerts** | Metric, log, and activity log alert rules |
| **Action Groups** | Notification routing (email, SMS, webhook, ITSM, Logic Apps) |
| **Azure Dashboards** | Shared visualization of metrics and KQL query results |
| **Network Watcher** | Network diagnostics, NSG flow logs, connection monitor |

## Repository Structure

```
azure-observability/
├── modules/                        # Terraform modules
│   ├── log-analytics/              # Log Analytics Workspace
│   ├── application-insights/       # Application Insights instances
│   ├── monitor-alerts/             # Alert rules (metric, log, activity)
│   ├── action-groups/              # Notification action groups
│   ├── diagnostic-settings/        # Diagnostic settings for resources
│   ├── dashboards/                 # Azure Portal dashboards
│   └── network-watcher/            # Network Watcher + flow logs
├── environments/                   # Per-environment configurations
│   ├── dev/
│   ├── staging/
│   └── prod/
├── kql-queries/                    # Reusable KQL query library
│   ├── compute/
│   ├── networking/
│   ├── security/
│   ├── storage/
│   ├── database/
│   └── application/
├── docs/                           # Architecture and runbook docs
├── scripts/                        # Helper scripts
├── main.tf                         # Root Terraform configuration
├── variables.tf                    # Root input variables
├── outputs.tf                      # Root outputs
├── providers.tf                    # Provider configuration
└── terraform.tfvars.example        # Example variable values
```

## Prerequisites

- Terraform >= 1.5
- Azure CLI >= 2.50
- An Azure subscription with `Contributor` and `Monitoring Contributor` roles
- A resource group (or permissions to create one)

## Quick Start

```bash
# Authenticate
az login
az account set --subscription "<SUBSCRIPTION_ID>"

# Initialize
cd azure-observability/environments/dev
terraform init

# Plan
terraform plan -out=tfplan

# Apply
terraform apply tfplan
```

## Design Principles

1. **Azure-native only** — Every component uses first-party Azure services
2. **Centralized logging** — All resource diagnostics flow to a single Log Analytics Workspace
3. **Environment parity** — Same modules, different variable values per environment
4. **Alert-driven** — Preconfigured alert rules for compute, network, security, and application tiers
5. **KQL-first** — Reusable query library for investigations, dashboards, and log-based alerts
6. **Least privilege** — Managed identities and scoped RBAC for monitoring access
