<#
.SYNOPSIS
    Standardized offboarding: Disables user, clears groups, and moves to Disabled OU.
#>
param([Parameter(Mandatory=$true)][string]$UserName)

$DisabledOU = "OU=Disabled Users,DC=yourdomain,DC=com" # Update this path!

try {
    Write-Host "Starting offboarding for $UserName..." -ForegroundColor Cyan
    
    # 1. Disable and Set Description
    Set-ADUser -Identity $UserName -Enabled $false -Description "Offboarded on $(Get-Date)"
    
    # 2. Clear Groups (Prevents security bloat)
    $User = Get-ADUser -Identity $UserName -Properties MemberOf
    $User.MemberOf | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $UserName -Confirm:$false }
    
    # 3. Move to OU
    Move-ADObject -Identity $User.DistinguishedName -TargetPath $DisabledOU
    
    Write-Host "User $UserName successfully offboarded and moved to $DisabledOU." -ForegroundColor Green
}
catch {
    Write-Error "Offboarding failed: $($_.Exception.Message)"
}
