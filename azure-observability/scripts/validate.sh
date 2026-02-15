#!/usr/bin/env bash
# Validate Terraform configuration across all environments.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Validating root module ==="
terraform -chdir="$ROOT_DIR" init -backend=false
terraform -chdir="$ROOT_DIR" validate

for env_dir in "$ROOT_DIR"/environments/*/; do
  env_name="$(basename "$env_dir")"
  echo ""
  echo "=== Validating environment: $env_name ==="
  terraform -chdir="$env_dir" init -backend=false
  terraform -chdir="$env_dir" validate
done

echo ""
echo "All environments validated successfully."
