# 🚀 Enterprise Systems Engineering Toolkit

A comprehensive, production-ready automation framework designed for **Senior/Principal Systems Engineers**. This repository moves beyond basic administration by implementing proactive monitoring, security hardening, and hybrid-cloud integration.

---

## 🧠 The Central Brain: Master Health Check
The root of this repository contains `Invoke-DailyHealthCheck.ps1`. This controller orchestrates the various modules to generate a unified daily status report, ensuring "Single Pane of Glass" visibility into infrastructure health.

### 📋 Executive Summary Features:
* **Automated Reporting**: Aggregates data into a professional HTML email dashboard.
* **Modular Design**: Each script can be run independently or as part of the suite.
* **Environment Agnostic**: Uses a centralized `Configs/` layer for easy portability across environments.

---

## 📂 Core Modules

### 🛡️ [Security & Compliance](./Scripts/Security/)
*Focus: Attack Surface Reduction & Auditing.*
* **Local Admin Inventory**: Detects "Permission Creep" across the fleet.
* **Server Hardening**: Disables legacy protocols (SMBv1/LLMNR).
* **TLS Audit**: Identifies non-compliant encryption standards (TLS 1.0/1.1).

### 🖥️ [Virtualization & Clustering](./Scripts/Virtualization/)
*Focus: Hyper-V Fabric Management & Optimization.*
* **HA Provisioning**: Automates Clustered VM deployment.
* **Live Migration**: Orchestrates zero-downtime host maintenance.
* **Orphaned Disk Discovery**: Reclaims "Ghost Storage" from CSVs.

### 💾 [Storage Management](./Scripts/Storage/)
*Focus: SAN Provisioning & Capacity Planning.*
* **Unity LUN Provisioning**: Standardized EMC Unity storage automation.
* **Capacity Reporting**: Early-warning systems for disk exhaustion.
* **Snapshot Cleanup**: Automated aging of checkpoints to prevent volume stun.

### 🧪 [Disaster Recovery & Validation](./Scripts/Recovery/)
*Focus: Resilience & Verification.*
* **Backup Integrity**: Validates file headers to prevent "Silent Failure."
* **AD Recycle Bin**: Rapid identity recovery workflows for accidental deletions.
* **DHCP Export**: Config backups for critical networking roles.

### ☁️ [Hybrid / Cloud Bridge](./Scripts/Hybrid/)
*Focus: Entra ID (Azure AD) & M365 Integration.*
* **Delta Sync**: Immediate on-prem to cloud identity updates via AD Connect.
* **License Audit**: Cost-optimization by identifying unused M365 accounts.
* **Hybrid Connectivity**: Latency and port testing for VPN/ExpressRoute tunnels.

### 🛠️ [System Maintenance](./Scripts/Maintenance/)
*Focus: Automated Hygiene.*
* **Test-ServerUptime.ps1**: Flags systems requiring maintenance reboots to resolve "Ghost Issues."
* **Self-Healing Services**: Monitors and restarts failed auto-start services.
* **Patch Management**: Orchestrated Windows Updates and reboot scheduling.

### 📧 [Mail & Notifications](./Scripts/Notifications/)
*Focus: Communication & Alerting.*
* **HTML Reporting**: Programmatic conversion of PS Objects to clean, CSS-styled tables.
* **Critical Alerts**: High-priority notification logic for system failures.
* **Queue Monitoring**: Ensures reliability of the notification path.

### ⚙️ [General Utilities](./Scripts/Utility/)
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

### 2. Configuration
1. Navigate to the `Configs/` folder.
2. Rename `Settings.Sample.json` to `Settings.json`.
3. Update the `SmtpServer` and `ToAddress` with your environment details.
4. Add target hostnames/IPs to `Servers.txt`.

### 3. Deployment
1. **Clone the Repo:**
   ```powershell
   git clone [https://github.com/your-username/Systems-Engineering-Toolkit.git](https://github.com/your-username/Systems-Engineering-Toolkit.git)
