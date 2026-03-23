# ☁️ Hybrid / Cloud Bridge

This module acts as the "connective tissue" between on-premises Active Directory and the Microsoft Entra ID (Azure AD) cloud environment.

## 📋 Scripts Included

### 1. Sync-ADToEntra.ps1
* **Purpose:** Manually triggers a Delta Synchronization cycle via AD Connect.
* **Value:** Eliminates the standard 30-minute wait time for identity changes (passwords, group memberships) to reflect in M365.

### 2. Get-M365LicenseAudit.ps1
* **Purpose:** Identifies licensed users who have not signed in within the last 30 days.
* **Value:** **Cost Optimization.** Allows the organization to reclaim unused licenses and reduce monthly cloud spend.

### 3. Test-HybridConnectivity.ps1
* **Purpose:** Tests network latency and port availability (443/TCP) for critical cloud endpoints.
* **Value:** Rapidly differentiates between an "Identity Issue" and a "Network/VPN Issue."

## 🔑 Prerequisites
* **Microsoft Graph PowerShell SDK** (for License Audits).
* **ADSync Module** (must be run on the AD Connect staging/primary server).
