# Systems Engineering Toolkit 🛠️

A collection of PowerShell-based automation scripts for Systems Engineers to manage Windows environments, Active Directory, Virtualization, and Storage.

---

## 📂 Repository Structure

* `scripts/user-management/` - AD auditing, profile resets, and offboarding.
* `scripts/storage/` - Array provisioning, quotas, and capacity reporting.
* `scripts/maintenance/` - Patching, uptime checks, and system cleaning.
* `scripts/virtualization/` - Hyper-V and Cluster management.
* `scripts/utility/` - Remote connectivity, file operations, and networking checks.

---

## 🚀 Quick Start Guide

### 1. Prerequisites
* **PowerShell Version:** 5.1 or PowerShell Core (7.x).
* **Permissions:** Must be run in an **Elevated (Admin)** session.
* **Modules:** Ensure `ActiveDirectory`, `PSWindowsUpdate`, and `Unity-Powershell` are installed.

### 2. Execution Policy
Run this in your session to allow local scripts to execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
