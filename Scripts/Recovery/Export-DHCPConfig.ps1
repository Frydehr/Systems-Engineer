<#
.SYNOPSIS
    Exports DHCP Server configuration for disaster recovery.
#>
$BackupDir = "C:\Backups\DHCP"
if (!(Test-Path $BackupDir)) { New-Item $BackupDir -ItemType Directory }

$Date = Get-Date -Format "yyyyMMdd"
$BackupFile = "$BackupDir\DHCP_Config_$Date.xml"

try {
    Export-DhcpServer -File $BackupFile -Force
    Write-Host "DHCP Configuration successfully exported to $BackupFile" -ForegroundColor Green
} catch {
    Write-Error "Failed to export DHCP Configuration. Ensure you have Admin rights."
}
