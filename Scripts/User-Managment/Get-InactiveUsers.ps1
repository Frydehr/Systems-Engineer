<#
.SYNOPSIS
    Finds and lists users who haven't logged in for X days.
.PARAMETER Days
    Threshold for inactivity (Default: 90).
#>
param([int]$Days = 90)

$Time = (Get-Date).AddDays(-$Days)
Write-Host "Searching for users inactive since $Time..." -ForegroundColor Yellow

Get-ADUser -Filter 'LastLogonDate -lt $Time' -Properties LastLogonDate | 
    Select-Object Name, SamAccountName, LastLogonDate | 
    Sort-Object LastLogonDate
