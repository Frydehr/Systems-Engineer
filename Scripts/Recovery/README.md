# 🧪 Disaster Recovery & Validation

A senior-level systems approach to DR: This module focuses on the **validation** of backups and the **rapid recovery** of critical infrastructure services.

## 📋 Scripts Included

### 1. Test-BackupIntegrity.ps1
* **Purpose:** Validates the health of backup files based on age and file size metadata.
* **Value:** Prevents "Silent Failure" where backup jobs report success but produce 0KB or corrupted files.

### 2. Get-ADRecycleBinStatus.ps1
* **Purpose:** Verifies the Active Directory Recycle Bin state and audits recently deleted objects.
* **Value:** Reduces RTO (Recovery Time Objective) for accidental deletions from hours to seconds.

### 3. Export-DHCPConfig.ps1
* **Purpose:** Automates the export of DHCP scopes, reservations, and options.
* **Value:** Ensures that in a total site failure, networking services can be restored on a fresh VM in minutes.

## ⚠️ Requirements
* **Active Directory Module** (RSAT) required for AD scripts.
* **DHCP Server Role** must be installed on the target for exports.
