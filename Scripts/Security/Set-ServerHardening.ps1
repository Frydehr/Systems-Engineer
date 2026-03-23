<#
.SYNOPSIS
    Disables insecure protocols (SMBv1 and LLMNR) to harden the server.
#>
# Disable SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

# Disable LLMNR via Registry
$RegistryPath = "HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient"
if (!(Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force }
Set-ItemProperty -Path $RegistryPath -Name "EnableMulticast" -Value 0 -Type DWord

Write-Host "Hardening complete: SMBv1 and LLMNR disabled." -ForegroundColor Green
