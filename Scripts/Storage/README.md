# 💾 Storage Management

This module provides the tools necessary for provisioning, auditing, and optimizing multi-tier storage environments. It covers the lifecycle of data from initial LUN creation to automated cleanup and quota enforcement.

## 📋 Scripts Included

### 1. New-UnityLun.ps1
* **Purpose:** Automates the provisioning of Logical Unit Numbers (LUNs) on EMC Unity storage arrays.
* **Value:** Eliminates manual errors in storage allocation and ensures consistent naming conventions across the SAN.

### 2. Get-StorageReport.ps1
* **Purpose:** Performs capacity auditing across the fleet with built-in threshold warnings.
* **Value:** Provides early-warning alerts for volumes approaching capacity, preventing application crashes due to disk exhaustion.

### 3. Invoke-SnapshotCleanup.ps1
* **Purpose:** Identifies and removes aged Hyper-V checkpoints and storage snapshots.
* **Value:** Reclaims disk space and prevents the performance degradation (and potential volume "stun") associated with long-running snapshots.

### 4. New-FolderQuota.ps1
* **Purpose:** Implements File Server Resource Manager (FSRM) based limit enforcement on file shares.
* **Value:** Protects shared storage from being overwhelmed by a single user or runaway process, ensuring fair resource distribution.

### 5. Mount-NetworkShare.ps1
* **Purpose:** Provides a robust method for mapping remote file resources with error handling and persistence checks.
* **Value:** Standardizes how servers connect to remote data, reducing "Broken Path" errors in automated workflows.

## ⚙️ Best Practices
For enterprise environments, it is recommended to run the `Get-StorageReport.ps1` as part of the **Master Health Check** to maintain a 24/7 view of storage health.
