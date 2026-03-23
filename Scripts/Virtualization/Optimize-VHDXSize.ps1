<#
.SYNOPSIS
    Compacts dynamic VHDX files to reduce physical footprint on the CSV.
#>
param([Parameter(Mandatory=$true)][string]$Path)
# Note: VM must be turned off to optimize the disk
Mount-VHD -Path $Path -ReadOnly
Optimize-VHD -Path $Path -Mode Full
Dismount-VHD -Path $Path
Write-Host "Optimization of $Path complete." -ForegroundColor Green
