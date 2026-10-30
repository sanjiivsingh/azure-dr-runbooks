# Runbook: Azure Storage GRS Account Failover

## Objective
Execute customer-managed failover for Geo-Redundant Storage (RA-GRS) accounts during secondary region disaster recovery.

## Prerequisites
- Storage Account configured with GRS or GZRS replication.
- Verify `lastSyncTime` to quantify data loss risk (RPO).

## Procedure
```bash
# 1. Inspect Replication Lag
az storage account show \
  --name stplatformprodeastus \
  --resource-group rg-storage-prod \
  --query "geoReplicationStats"

# 2. Trigger Failover to Secondary Region
az storage account failover \
  --name stplatformprodeastus \
  --resource-group rg-storage-prod \
  --yes

# 3. Post-Failover Verification
# Note: Account becomes LRS in the failover region. Convert back to GRS when primary region recovers.
az storage account show \
  --name stplatformprodeastus \
  --resource-group rg-storage-prod \
  --query "statusOfPrimary"
```
