# 🛠️ General Utilities

This module contains the foundational "Swiss Army Knife" scripts that support day-to-day operations. These tools focus on standardized access, rapid asset discovery, and automated data lifecycle management.

## 📋 Scripts Included

### 1. Connect-RemoteServer.ps1
* **Purpose:** Acts as a standardized entry point for remote PowerShell management.
* **Value:** Ensures consistent session configurations and security protocols are used every time an engineer connects to a remote node.

### 2. Get-SystemInventory.ps1
* **Purpose:** Programmatically pulls Hardware Models, Serial Numbers, and OS specifications.
* **Value:** Vital for asset management and warranty tracking. This script turns a manual "spreadsheet hunt" into a 5-second automated query.

### 3. Search-FileContent.ps1
* **Purpose:** Performs recursive text searching across large directory structures.
* **Value:** Drastically reduces "Mean Time to Repair" (MTTR) during log analysis by pinpointing specific error codes across thousands of log files instantly.

### 4. Invoke-FileArchive.ps1
* **Purpose:** Automates the aging, compression, and relocation of stale data.
* **Value:** Implements a proactive data retention policy, ensuring that expensive "Hot Storage" isn't wasted on old logs or temporary files.

## 🚀 Usage Tip
These utilities are designed to be "pipeable." For example, you can pipe the output of `Get-SystemInventory.ps1` directly into your reporting scripts for an instant hardware audit.
