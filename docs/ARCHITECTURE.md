# Architecture Decision Record (ADR) - Disaster Recovery Architecture

## Context
Mission-critical Azure workloads require formalized Disaster Recovery Runbooks to ensure deterministic recovery against regional outages, ransomware corruption, or accidental deletion.

## Decisions

### 1. Active-Passive Cold-Standby for Compute
- **Decision**: Primary region runs production AKS; DR region infrastructure is defined in Terraform and provisioned on-demand, restoring application state via Velero.
- **Rationale**: Reduces standby compute infrastructure cost while meeting a 30-minute RTO.

### 2. Native Soft-Delete & Purge Protection
- **Decision**: Enforce 90-day soft-delete and purge protection across Key Vault and Storage.
- **Rationale**: Guarantees zero data loss against accidental deletion or credential compromise without incurring duplicate operational storage fees.

### 3. GRS / GZRS for Stateful Persistence
- **Decision**: Geo-Redundant storage with customer-managed failover capabilities.
- **Rationale**: Retains primary authority during split-brain risks, allowing operators to verify replication lag before switching DNS.
