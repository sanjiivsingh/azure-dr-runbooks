#!/usr/bin/env bash
# ==============================================================================
# Script: keyvault_recover.sh
# Purpose: Recovers soft-deleted Key Vault instances and deleted secrets
# Requirements: az cli >= 2.60.0
# ==============================================================================

set -euo pipefail

VAULT_NAME="${1:-}"
LOCATION="${2:-eastus}"

if [[ -z "$VAULT_NAME" ]]; then
  echo "Usage: $0 <vault-name> [location]"
  exit 1
fi

echo "[INFO] Checking for deleted Key Vault: ${VAULT_NAME}..."
DELETED_STATE=$(az keyvault list-deleted --query "[?name=='${VAULT_NAME}'].id" -o tsv)

if [[ -n "$DELETED_STATE" ]]; then
  echo "[INFO] Found deleted vault. Triggering recovery in ${LOCATION}..."
  az keyvault recover --name "${VAULT_NAME}" --location "${LOCATION}"
  echo "[SUCCESS] Key Vault ${VAULT_NAME} successfully recovered from soft-delete."
else
  echo "[WARN] Key Vault ${VAULT_NAME} was not found in soft-deleted state."
fi
