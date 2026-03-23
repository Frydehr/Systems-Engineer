<#
.SYNOPSIS
    Pulls physical or virtual hardware specifications from the local system.
#>
$Computer = Get-CimInstance -ClassName Win32_ComputerSystem
$OS = Get-CimInstance -ClassName Win32_OperatingSystem
$Bios = Get-CimInstance -ClassName Win32_BIOS

[PSCustomObject]@{
    Model        = $Computer.Model
    SerialNumber = $Bios.SerialNumber
    TotalRAM_GB  = [Math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
    CPU_Count    = $Computer.NumberOfLogicalProcessors
    OS_Version   = $OS.Caption
    InstallDate  = $OS.InstallDate
} | Format-List
