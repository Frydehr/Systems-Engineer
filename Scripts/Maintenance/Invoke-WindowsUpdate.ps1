<#
.SYNOPSIS
    Installs pending Microsoft Updates using the PSWindowsUpdate module.

.DESCRIPTION
    Checks for, downloads, and installs all available Windows Updates. 
    Includes logic to install the required NuGet provider and PSWindowsUpdate module if missing.

.PARAMETER AutoReboot
    If switched on, the server will reboot automatically if required by the updates.
#>

param (
    [Parameter(Mandatory=$false)]
    [switch]$AutoReboot
)

# --- Admin Check ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as an Administrator."
    return
}

# --- Environment Setup ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (!(Get-Module -ListAvailable -Name "PSWindowsUpdate")) {
    Write-Host "PSWindowsUpdate module not found. Configuring environment..." -ForegroundColor Magenta
    
    if (!(Get-PackageProvider -Name "NuGet" -ErrorAction SilentlyContinue)) {
        Write-Host "Installing NuGet Provider..." -ForegroundColor Cyan
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    }
    
    Write-Host "Installing PSWindowsUpdate Module..." -ForegroundColor Cyan
    Install-Module PSWindowsUpdate -Force -Confirm:$false -Scope CurrentUser
}

Import-Module PSWindowsUpdate

# --- Execution ---
Write-Host "Checking for and installing updates..." -ForegroundColor Yellow

$Params = @{
    Install = $true
    AcceptAll = $true
}

if ($AutoReboot) {
    $Params.Add("AutoReboot", $true)
    Write-Host "Auto-Reboot is ENABLED." -ForegroundColor Red
} else {
    $Params.Add("IgnoreReboot", $true)
    Write-Host "Ignoring reboot requests. Manual reboot may be required." -ForegroundColor Cyan
}

try {
    Get-WindowsUpdate @Params -ErrorAction Stop
    Write-Host "Update process complete." -ForegroundColor Green
}
catch {
    Write-Error "An error occurred during the update process: $($_.Exception.Message)"
}
