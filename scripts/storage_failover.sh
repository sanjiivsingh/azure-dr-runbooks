#!/usr/bin/env bash
# ==============================================================================
# Script: storage_failover.sh
# Purpose: Validates replication lag and triggers customer-initiated GRS failover
# Requirements: az cli >= 2.60.0
# ==============================================================================

set -euo pipefail

ACCOUNT_NAME="${1:-}"
RESOURCE_GROUP="${2:-}"

if [[ -z "$ACCOUNT_NAME" || -z "$RESOURCE_GROUP" ]]; then
  echo "Usage: $0 <storage-account-name> <resource-group-name>"
  exit 1
fi

echo "[INFO] Inspecting replication status for Storage Account ${ACCOUNT_NAME}..."
LAST_SYNC_TIME=$(az storage account show \
  --name "${ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --query "geoReplicationStats.lastSyncTime" -o tsv)

echo "[INFO] Secondary replication LastSyncTime: ${LAST_SYNC_TIME}"
echo "[WARN] Triggering failover will convert secondary location to primary and update DNS."
echo "[INFO] To proceed in production, run:"
echo "       az storage account failover --name \"${ACCOUNT_NAME}\" --resource-group \"${RESOURCE_GROUP}\" --yes"
