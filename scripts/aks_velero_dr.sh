#!/usr/bin/env bash
# ==============================================================================
# Script: aks_velero_dr.sh
# Purpose: Orchestrates on-demand backup and DR restoration for AKS clusters
# Requirements: az cli >= 2.60.0, kubectl >= 1.29, velero cli >= 1.14
# ==============================================================================

set -euo pipefail

MODE="${1:-}"
CLUSTER_NAME="${2:-aks-prod-eastus}"
RESOURCE_GROUP="${3:-rg-aks-prod-eastus}"
BACKUP_NAME="${4:-aks-backup-$(date +%Y%m%d%H%M%S)}"

usage() {
  echo "Usage: $0 {backup|restore|status} [cluster-name] [resource-group] [backup-name]"
  exit 1
}

if [[ -z "$MODE" ]]; then
  usage
fi

case "$MODE" in
  backup)
    echo "[INFO] Initiating AKS Cluster Backup: ${BACKUP_NAME}..."
    az aks get-credentials --resource-group "${RESOURCE_GROUP}" --name "${CLUSTER_NAME}" --overwrite-existing
    velero backup create "${BACKUP_NAME}" \
      --include-namespaces production,ingress-nginx \
      --snapshot-volumes \
      --wait
    echo "[SUCCESS] Backup ${BACKUP_NAME} completed."
    velero backup describe "${BACKUP_NAME}"
    ;;

  restore)
    echo "[INFO] Restoring cluster state from backup: ${BACKUP_NAME}..."
    az aks get-credentials --resource-group "${RESOURCE_GROUP}" --name "${CLUSTER_NAME}" --overwrite-existing
    velero restore create --from-backup "${BACKUP_NAME}" \
      --restore-volumes \
      --wait
    echo "[SUCCESS] Restore initiated. Verifying workload health..."
    kubectl get pods -n production
    ;;

  status)
    echo "[INFO] Fetching Velero backup history..."
    velero backup get
    ;;

  *)
    usage
    ;;
esac
