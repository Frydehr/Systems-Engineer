<#
.SYNOPSIS
    Initiates an interactive PowerShell Remoting session with a target server.

.DESCRIPTION
    Standardizes remote connections by prompting for credentials and verifying 
    connectivity before attempting to enter the session.

.PARAMETER Server
    The FQDN or IP address of the remote system.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Server
)

# --- Connectivity Check ---
Write-Host "Verifying connectivity to $Server..." -ForegroundColor Cyan
if (!(Test-Connection -ComputerName $Server -Count 1 -Quiet)) {
    Write-Error "Server $Server is unreachable. Please check the network path or VPN."
    return
}

# --- Credential Handling ---
$UserCredential = Get-Credential -UserName "$env:USERDOMAIN\$env:USERNAME" -Message "Enter credentials for $Server"

if ($null -eq $UserCredential) {
    Write-Warning "Credential prompt cancelled. Exiting."
    return
}

# --- Session Initiation ---
try {
    Write-Host "Attempting to establish PS-Session..." -ForegroundColor Green
    Enter-PSSession -ComputerName $Server -Credential $UserCredential -ErrorAction Stop
}
catch {
    Write-Error "Failed to connect to $Server. Ensure WinRM is enabled (Enable-PSRemoting)."
}
