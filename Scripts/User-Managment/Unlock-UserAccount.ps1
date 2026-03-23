<#
.SYNOPSIS
    Unlocks an AD user account and displays the lockout time.
#>
param([Parameter(Mandatory=$true)][string]$UserName)

$User = Get-ADUser -Identity $UserName -Properties LockedOut
if ($User.LockedOut) {
    Unlock-ADAccount -Identity $UserName
    Write-Host "Account '$UserName' has been successfully unlocked." -ForegroundColor Green
} else {
    Write-Host "Account '$UserName' is not currently locked." -ForegroundColor Cyan
}
