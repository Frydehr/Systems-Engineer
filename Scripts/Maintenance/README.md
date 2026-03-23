# 🛠️ System Maintenance

This module automates the "Hygiene" tasks of a Systems Engineer. By moving these from manual checklists to scheduled scripts, we ensure consistent uptime and performance across the server fleet.

## 📋 Scripts Included

### 1. Invoke-WindowsUpdate.ps1
* **Purpose:** Programmatically manages Microsoft patches and handles necessary system reboots.
* **Value:** Ensures the environment stays patched against vulnerabilities without requiring manual GUI interaction for every server.

### 2. Clear-SystemTempFiles.ps1
* **Purpose:** Targets and clears temporary directories, log dumps, and Windows Update caches.
* **Value:** Proactively prevents "Disk Full" outages—a leading cause of preventable system downtime.

### 3. Get-ServiceHealthReport.ps1
* **Purpose:** Monitors the status of "Automatic" services and attempts to restart those in a "Stopped" state.
* **Value:** Acts as a first-responder for critical application services, increasing the "Self-Healing" capability of the infrastructure.

### 4. Test-ServerUptime.ps1
* **Purpose:** Identifies systems that have been running for excessive periods without a reboot.
* **Value:** Flags potential "Ghost Issues" where pending updates or memory leaks may be degrading system stability.

### 5. Backup-EventLogs.ps1
* **Purpose:** Archives and clears System, Application, and Security event logs.
* **Value:** Maintains a historical audit trail for compliance (SOX/PCI) while preventing logs from consuming excessive disk space.

## ⚙️ Best Practices
These scripts are designed to be triggered via the **Master Health Check** or as independent scheduled tasks during defined maintenance windows.
