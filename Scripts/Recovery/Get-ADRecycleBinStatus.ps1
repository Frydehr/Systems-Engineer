<#
.SYNOPSIS
    Checks if AD Recycle Bin is enabled and lists deleted objects.
#>
$Features = Get-ADOptionalFeature -Filter 'Name -like "Recycle Bin Feature"'
$Status = Get-ADOptionalFeature -Identity $Features.Guid | Select-Object -ExpandProperty EnabledScopes

if ($Status) {
    Write-Host "AD Recycle Bin is ENABLED." -ForegroundColor Green
    Write-Host "Recent Deleted Objects (Last 24h):" -ForegroundColor Cyan
    Get-ADObject -Filter 'isDeleted -eq $true' -IncludeDeletedObjects -Properties whenChanged | 
        Where-Object { $_.whenChanged -gt (Get-Date).AddDays(-1) } | Select-Object Name, DistinguishedName, whenChanged
} else {
    Write-Warning "AD Recycle Bin is DISABLED. High risk of data loss on accidental deletion."
}
