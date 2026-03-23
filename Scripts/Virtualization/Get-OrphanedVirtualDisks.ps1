<#
.SYNOPSIS
    Identifies .vhdx files taking up space that are not linked to any existing VM.
#>
$AttachedDisks = (Get-VM | Get-VMHardDiskDrive).Path
$StoragePath = "C:\ClusterStorage\Volume1"
$AllDisks = Get-ChildItem $StoragePath -Filter *.vhdx -Recurse

foreach ($Disk in $AllDisks) {
    if ($AttachedDisks -notcontains $Disk.FullName) {
        Write-Host "Orphaned Disk Found: $($Disk.FullName)" -ForegroundColor Red
    }
}
