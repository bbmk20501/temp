# Azure Network Observability

End-to-end network observability for Azure Cloud Platform using **Azure-native tools only** — focused on Azure Firewall, Application Gateway, Load Balancer, DNS, connectivity, and ExpressRoute.

## Architecture Overview

```
+------------------------------------------------------------------+
|                   Azure Network Observability                     |
+------------------------------------------------------------------+
|                                                                    |
|  +-----------------+    +-------------------+    +--------------+  |
|  | Azure Firewall  |--->|                   |--->| Azure        |  |
|  +-----------------+    |                   |    | Dashboards   |  |
|  +-----------------+    |   Log Analytics   |    +--------------+  |
|  | App Gateway     |--->|   Workspace       |                      |
|  +-----------------+    |                   |    +--------------+  |
|  +-----------------+    |   (Central Sink)  |--->| Azure Monitor|  |
|  | Load Balancer   |--->|                   |    | Alerts &     |  |
|  +-----------------+    |                   |    | Action Groups|  |
|  +-----------------+    |                   |    +--------------+  |
|  | DNS Zones &     |--->|                   |                      |
|  | Resolver        |    |                   |                      |
|  +-----------------+    |                   |                      |
|  +-----------------+    |                   |                      |
|  | ExpressRoute    |--->|                   |                      |
|  | Circuit + GW    |    |                   |                      |
|  +-----------------+    +-------------------+                      |
|  +-----------------+           |                                   |
|  | Network Watcher |-----------+                                   |
|  | (NSG Flow Logs) |                                               |
|  +-----------------+                                               |
|                                                                    |
+------------------------------------------------------------------+
```

## Azure-Native Services Monitored

| Service | What's Collected |
|---------|-----------------|
| **Azure Firewall** | Network rules, application rules, threat intel, IDPS, DNS proxy, SNAT health, throughput |
| **Application Gateway** | Access logs, performance logs, WAF firewall logs, backend health, capacity |
| **Load Balancer** | Health probes, alert events, SNAT ports, byte/packet counts, VIP availability |
| **Azure DNS** | Public zone queries, private zone resolution, DNS Private Resolver logs |
| **ExpressRoute** | Circuit ARP/BGP availability, throughput, gateway CPU, route changes |
| **Network Watcher** | NSG flow logs, traffic analytics |

## Supporting Infrastructure

| Service | Purpose |
|---------|---------|
| **Log Analytics Workspace** | Centralized log ingestion and KQL query engine |
| **Azure Monitor Alerts** | 12 preconfigured networking alert rules |
| **Action Groups** | Notification routing (email, webhook) with critical/warning/info tiers |
| **Azure Dashboards** | 10-widget networking overview dashboard |

## Repository Structure

```
azure-observability/
├── modules/                           # Terraform modules
│   ├── log-analytics/                 # Log Analytics Workspace + solutions
│   ├── firewall-diagnostics/          # Azure Firewall diagnostic settings
│   ├── appgw-diagnostics/             # Application Gateway diagnostic settings
│   ├── lb-diagnostics/                # Load Balancer diagnostic settings
│   ├── dns-diagnostics/               # DNS public/private/resolver diagnostics
│   ├── expressroute-diagnostics/      # ExpressRoute circuit + gateway diagnostics
│   ├── monitor-alerts/                # Networking alert rules
│   ├── action-groups/                 # Notification action groups
│   ├── dashboards/                    # Azure Portal dashboards
│   ├── network-watcher/               # NSG flow logs + traffic analytics
│   └── diagnostic-settings/           # Generic catch-all diagnostics
├── environments/                      # Per-environment configurations
│   ├── dev/
│   ├── staging/
│   └── prod/
├── kql-queries/                       # Reusable KQL query library
│   ├── firewall/                      # Network rules, app rules, threat intel, DNS proxy, SNAT
│   ├── app-gateway/                   # Access logs, backend health, WAF
│   ├── load-balancer/                 # Health probes, traffic, SNAT
│   ├── dns/                           # Query analytics, resolver
│   ├── expressroute/                  # Circuit availability, gateway performance
│   └── networking/                    # NSG flow logs, connectivity
├── docs/
├── scripts/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── terraform.tfvars.example
```

## Alert Rules (12 preconfigured)

| Alert | Severity | Service |
|-------|----------|---------|
| Firewall SNAT port exhaustion (>90%) | Critical | Azure Firewall |
| Firewall health degraded | Critical | Azure Firewall |
| Firewall Threat Intel hit | Critical | Azure Firewall |
| App Gateway unhealthy backends | Critical | Application Gateway |
| App Gateway 5xx error rate >5% | Warning | Application Gateway |
| WAF blocked spike (>100 in 10min) | Warning | Application Gateway |
| Load Balancer health probe degraded | Critical | Load Balancer |
| Load Balancer SNAT exhaustion (>80%) | Warning | Load Balancer |
| ExpressRoute ARP availability <99.9% | Critical | ExpressRoute |
| ExpressRoute BGP availability <99.9% | Critical | ExpressRoute |
| ExpressRoute Gateway CPU >80% | Warning | ExpressRoute |
| DNS query failure rate elevated | Warning | DNS |

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
2. **Networking-focused** — Purpose-built for Firewall, App Gateway, LB, DNS, and ExpressRoute
3. **Centralized logging** — All resource diagnostics flow to a single Log Analytics Workspace
4. **Environment parity** — Same modules, different variable values per environment
5. **Alert-driven** — 12 preconfigured alert rules covering all six networking services
6. **KQL-first** — 14 query files with 80+ ready-to-use queries for investigation and dashboards
