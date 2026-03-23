# 🛡️ Security & Compliance Module

This module contains scripts designed to reduce the attack surface of the internal infrastructure and ensure alignment with industry-standard hardening practices.

## 📋 Scripts Included

### 1. Test-LocalAdminInventory.ps1
* **Purpose:** Scans the server fleet to identify members of the `Administrators` group.
* **Value:** Detects "Permission Creep" and ensures only authorized service accounts and Tier-0 admins have elevated rights.

### 2. Set-ServerHardening.ps1
* **Purpose:** Programmatically disables legacy protocols (SMBv1, LLMNR).
* **Value:** Protects against lateral movement and Man-in-the-Middle (MitM) attacks like NTLM relaying.

### 3. Audit-TLSVersion.ps1
* **Purpose:** Audits the registry for enabled/disabled Schannel protocols.
* **Value:** Identifies servers still using deprecated TLS 1.0/1.1, helping maintain PCI-DSS or HIPAA compliance.

## 🚀 Usage
```powershell
# Example: Audit TLS on the local machine
.\Audit-TLSVersion.ps1
