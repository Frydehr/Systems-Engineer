<#
.SYNOPSIS
    Reports free space for all fixed disks and warns if below 10%.
#>
$Disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"

foreach ($Disk in $Disks) {
    $FreeGB = [Math]::Round($Disk.FreeSpace / 1GB, 2)
    $SizeGB = [Math]::Round($Disk.Size / 1GB, 2)
    $PercentFree = [Math]::Round(($FreeGB / $SizeGB) * 100, 2)
    
    $Output = "$($Disk.DeviceID) ($($Disk.VolumeName)) - $PercentFree% Free ($FreeGB GB of $SizeGB GB)"
    
    if ($PercentFree -lt 10) {
        Write-Host $Output -ForegroundColor Red
    } else {
        Write-Host $Output -ForegroundColor Green
    }
}
