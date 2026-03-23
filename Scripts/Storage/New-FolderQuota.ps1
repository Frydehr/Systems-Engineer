<#
.SYNOPSIS
    Applies a storage quota to a folder (Requires FSRM Role).
#>
param(
    [Parameter(Mandatory=$true)][string]$Path,
    [Parameter(Mandatory=$true)][string]$Limit = "10GB"
)

if (!(Get-Module -ListAvailable -Name FileServerResourceManager)) {
    Write-Error "FSRM module not found. Please install the File Server Resource Manager role."
    return
}

New-FsrmQuota -Path $Path -Size $Limit -Description "Managed by Systems Toolkit"
Write-Host "Quota of $Limit applied to $Path" -ForegroundColor Cyan
