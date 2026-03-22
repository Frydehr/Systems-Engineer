### 💾 Storage Management
The `CreateNewLUN.ps1` script provisions storage on EMC Unity arrays.

**Example Usage:**
```powershell
.\scripts\storage\CreateNewLUN.ps1 -LunName "SQL_Data_01" -LunSize 500GB -Hosts "Host_1","Host_2","Host_3"
