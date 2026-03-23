<#
.SYNOPSIS
    Forces a Delta Synchronization from On-Premises AD to Microsoft Entra ID.
#>
try {
    Write-Host "Starting Azure AD Connect Delta Sync..." -ForegroundColor Cyan
    Start-ADSyncSyncCycle -PolicyType Delta
    Write-Host "Sync triggered successfully. Check Synchronization Service Manager for progress." -ForegroundColor Green
} catch {
    Write-Error "ADSync module not found. Run this on your AD Connect server."
}
