<#
.SYNOPSIS
    Creates a new LUN on an EMC Unity Array and assigns it to specific hosts.

.DESCRIPTION
    This script automates the connection to the Unity Array, ensures the required 
    modules are installed, and provisions a LUN to a specified storage pool.

.PARAMETER LunName
    The name of the new LUN to be created.
.PARAMETER LunSize
    The size of the LUN (e.g., 250GB, 1TB).
.PARAMETER Hosts
    An array of host names to which the LUN should be presented.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$LunName,

    [Parameter(Mandatory=$true)]
    [string]$LunSize,

    [Parameter(Mandatory=$true)]
    [string[]]$Hosts,

    [string]$SmtpServer = "unity01",
    [string]$StoragePool = "pool_1"
)

# --- Environment Setup ---
if (!(Get-Module -Name "Unity-Powershell" -ListAvailable)) {
    Write-Host "Unity-Powershell module not found. Installing..." -ForegroundColor Yellow
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module Unity-Powershell -Scope CurrentUser -AllowClobber -Force
}
Import-Module Unity-Powershell

# --- Connection ---
Write-Host "Connecting to EMC Unity Array: $SmtpServer" -ForegroundColor Cyan
try {
    Connect-Unity -Server $SmtpServer -ErrorAction Stop
    
    # --- LUN Creation ---
    Write-Host "Creating LUN '$LunName' ($LunSize) in $StoragePool..." -ForegroundColor Cyan
    New-UnityLun -Name $LunName `
                 -Pool $StoragePool `
                 -Size $LunSize `
                 -Host $Hosts `
                 -ErrorAction Stop

    Write-Host "Successfully created and assigned LUN." -ForegroundColor Green
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}
finally {
    Write-Host "Disconnecting from Unity..." -ForegroundColor Gray
    Disconnect-Unity
}

Write-Host "Process Complete."
