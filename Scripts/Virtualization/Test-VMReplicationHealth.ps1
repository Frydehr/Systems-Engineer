<#
.SYNOPSIS
    Checks the health of VM replication and alerts if state is not 'Normal'.
#>
$ReplicaHealth = Get-VMReplication | Where-Object {$_.Health -ne "Normal"}
if ($ReplicaHealth) {
    Write-Warning "Replication issues detected on $($ReplicaHealth.Count) VMs."
    $ReplicaHealth | Select-Object Name, Health, Mode, LastReplicationTime
} else {
    Write-Host "All VM Replications are healthy." -ForegroundColor Green
}
