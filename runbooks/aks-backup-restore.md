# Runbook: AKS Disaster Recovery & Velero Restoration

## Objective
Restore mission-critical containerized workloads and stateful volume snapshots to an alternate region or rebuilt AKS cluster following cluster corruption or regional outage.

## Targets
- **RTO (Recovery Time Objective)**: < 30 minutes
- **RPO (Recovery Point Objective)**: < 1 hour (snapshot frequency)

## Prerequisites
- Secondary AKS cluster provisioned via Terraform.
- Blob Storage container containing Velero backup archive with immutable locks.
- Workload secrets backed up or referenced from Azure Key Vault CSI driver.

## Step-by-Step Recovery Procedure

### 1. Cluster Credential Acquisition
```bash
az aks get-credentials --resource-group rg-aks-dr-westus --name aks-dr-westus --overwrite-existing
```

### 2. Verify Velero Backup Availability
```bash
velero backup get
```

### 3. Trigger Stateful Restoration
```bash
velero restore create --from-backup aks-scheduled-backup-latest \
  --restore-volumes \
  --wait
```

### 4. Post-Restore Verification
```bash
kubectl get pods --all-namespaces
kubectl get pvc --all-namespaces
kubectl rollout status deployment/trading-engine -n production
```

### 5. DNS / Front Door Traffic Switch
Update Azure Front Door or Traffic Manager origin group endpoint from primary East US FQDN to secondary West US FQDN.
