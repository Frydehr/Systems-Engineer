<#
.SYNOPSIS
    Calculates system uptime and warns if it exceeds a threshold.
.PARAMETER MaxDays
    The number of days allowed before a warning is issued (Default: 30).
#>
param([int]$MaxDays = 30)

$LastBoot = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$Uptime = (Get-Date) - $LastBoot

Write-Host "System Uptime: $($Uptime.Days) Days, $($Uptime.Hours) Hours." -ForegroundColor Cyan

if ($Uptime.Days -gt $MaxDays) {
    Write-Host "CRITICAL: Server uptime exceeds $MaxDays days! Reboot recommended." -ForegroundColor Red
} else {
    Write-Host "Uptime is within acceptable limits." -ForegroundColor Green
}
