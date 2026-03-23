<#
.SYNOPSIS
    Identifies licensed M365 users with no sign-in activity in 30 days.
#>
# Requires Microsoft Graph PowerShell module
$CutoffDate = (Get-Date).AddDays(-30)

$Users = Get-MgUser -Property DisplayName, UserPrincipalName, AssignedLicenses, SignInActivity -All

$StaleUsers = $Users | Where-Object { 
    $_.AssignedLicenses.Count -gt 0 -and 
    $_.SignInActivity.LastSignInDateTime -lt $CutoffDate 
}

$StaleUsers | Select-Object DisplayName, UserPrincipalName, @{N='LastSignIn';E={$_.SignInActivity.LastSignInDateTime}} | 
    Export-Csv -Path "$PSScriptRoot\M365_Stale_Licenses.csv" -NoTypeInformation

Write-Host "Audit Complete. Found $($StaleUsers.Count) stale licensed accounts." -ForegroundColor Yellow
