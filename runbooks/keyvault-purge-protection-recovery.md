# Runbook: Azure Key Vault Soft-Delete Recovery

## Objective
Recover accidentally deleted Key Vaults or cryptographic keys/secrets protected by 90-day soft-delete retention and purge protection.

## Prerequisites
- User or Managed Identity must possess `Microsoft.KeyVault/vaults/read` and `Microsoft.KeyVault/locations/deletedVaults/read` permissions.

## Procedure
```bash
# 1. Identify deleted vault metadata
az keyvault list-deleted --resource-type vault

# 2. Recover deleted Key Vault
az keyvault recover --name kv-platform-prod-eastus --location eastus

# 3. Verify secret availability
az keyvault secret list --vault-name kv-platform-prod-eastus -o table
```
