<#
.SYNOPSIS
    Generates a report of resource allocation vs actual usage.
#>
Get-VM | Select-Object Name, State, CPUUsage, 
    @{N="AssignedMemoryMB";E={$_.MemoryAssigned/1MB}}, 
    @{N="Uptime";E={$_.Uptime}} | 
    Format-Table -AutoSize
