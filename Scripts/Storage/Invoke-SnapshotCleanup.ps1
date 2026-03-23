<#
.SYNOPSIS
    Identifies or removes old Hyper-V checkpoints to save space.
#>
param([int]$DaysOld = 7)

$Cutoff = (Get-Date).AddDays(-$DaysOld)
$OldSnapshots = Get-VMSnapshot -VMName * | Where-Object { $_.CreationTime -lt $Cutoff }

if ($OldSnapshots) {
    Write-Warning "Found $($OldSnapshots.Count) snapshots older than $DaysOld days."
    $OldSnapshots | Select-Object VMName, Name, CreationTime | Out-GridView -Title "Old Snapshots Found"
    # To automate deletion, add: $OldSnapshots | Remove-VMSnapshot -Confirm:$false
} else {
    Write-Host "No old snapshots found." -ForegroundColor Green
}
