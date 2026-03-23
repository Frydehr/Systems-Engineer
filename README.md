# 🚀 Enterprise Systems Engineering Toolkit

A comprehensive, production-ready automation framework designed for **Senior/Principal Systems Engineers**. This repository moves beyond basic administration by implementing proactive monitoring, security hardening, and hybrid-cloud integration.

---

## 🧠 The Central Brain: Master Health Check
The root of this repository contains `Invoke-DailyHealthCheck.ps1`. This controller orchestrates the various modules to generate a unified daily status report, ensuring "Single Pane of Glass" visibility into infrastructure health.

### 📋 Executive Summary Features:
* **Automated Reporting**: Aggregates data into a professional HTML email.
* **Modular Design**: Each script can be run independently or as part of the suite.
* **Cross-Platform Readiness**: Supports On-Prem (Hyper-V/Unity) and Cloud (Entra ID/M365).

---

## 📂 Core Modules

### 🛡️ [Security & Compliance](./Scripts/Security)
*Focus: Attack Surface Reduction & Auditing.*
* **Local Admin Inventory**: Detects "Permission Creep" across the fleet.
* **Server Hardening**: Disables legacy protocols (SMBv1/LLMNR).
* **TLS Audit**: Identifies non-compliant encryption standards (TLS 1.0/1.1).

### 🖥️ [Virtualization & Clustering](./scripts/virtualization/)
*Focus: Hyper-V Fabric Management & Optimization.*
* **HA Provisioning**: Automates Clustered VM deployment.
* **Live Migration**: Orchestrates zero-downtime host maintenance.
* **Orphaned Disk Discovery**: Reclaims "Ghost Storage" from CSVs.

### 💾 [Storage Management](./scripts/storage/)
*Focus: SAN Provisioning & Capacity Planning.*
* **Unity LUN Provisioning**: Standardized EMC Unity storage automation.
* **Capacity Reporting**: Early-warning systems for disk exhaustion.
* **Snapshot Cleanup**: Automated aging of checkpoints to prevent volume stun.

### 🧪 [Disaster Recovery & Validation](./scripts/recovery/)
*Focus: Resilience & Verification.*
* **Backup Integrity**: Validates file headers/metadata to prevent "Silent Failure."
* **AD Recycle Bin**: Rapid identity recovery workflows for accidental deletions.
* **DHCP Export**: Config backups for critical networking roles.

### ☁️ [Hybrid / Cloud Bridge](./scripts/hybrid/)
*Focus: Entra ID (Azure AD) & M365 Integration.*
* **Delta Sync**: Immediate on-prem to cloud identity updates via AD Connect.
* **License Audit**: Cost-optimization by identifying unused M365 accounts.
* **Hybrid Connectivity**: Latency and port testing for VPN/ExpressRoute tunnels.

### 🛠️ [System Maintenance](./scripts/maintenance/)
*Focus: Automated Hygiene.*
* **Patch Management**: Orchestrated Windows Updates and reboots.
* **Self-Healing Services**: Monitors and restarts failed auto-start services.
* **Uptime Tracking**: Flags systems requiring maintenance reboots.

### 📧 [Mail & Notifications](./scripts/notifications/)
*Focus: Communication & Alerting.*
* **HTML Reporting**: Programmatic conversion of PS Objects to clean tables.
* **Critical Alerts**: High-priority notification for system failures.
* **Queue Monitoring**: Ensures reliability of the notification path.

### ⚙️ [General Utilities](./scripts/utility/)
*Focus: Standardized Admin Tools.*
* **System Inventory**: Instant hardware/Serial Number/OS spec reporting.
* **Text Search**: Recursive log analysis for rapid troubleshooting.
* **File Archive**: Automated lifecycle management of stale data.

---

## 🛠️ Getting Started

### 1. Prerequisites
* PowerShell 5.1 or 7+
* RSAT Modules (Active Directory, Hyper-V, Failover Cluster)
* Microsoft Graph PowerShell SDK (for Cloud modules)

### 2. Deployment
1. **Clone the Repo:** ```powershell
   git clone [https://github.com/your-username/Systems-Engineering-Toolkit.git](https://github.com/your-username/Systems-Engineering-Toolkit.git)
