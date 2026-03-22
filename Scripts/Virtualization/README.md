### 🖥️ Virtualization & Clustering
The `New-ClusteredVM.ps1` script automates the deployment of highly available VMs on Hyper-V clusters.

**Note:** This script must be executed locally on a Cluster Node (not via Remote PowerShell).

**Example Usage:**
```powershell
.\Scripts\Virtualization\New-ClusteredVM.ps1 -VMName "WEB-SRV-01" -RAM 16GB -CPU 8
