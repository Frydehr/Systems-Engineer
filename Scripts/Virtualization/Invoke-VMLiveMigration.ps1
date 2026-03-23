<#
.SYNOPSIS
    Evacuates a specific cluster node by Live Migrating all VMs to a target node.
#>
param(
    [Parameter(Mandatory=$true)][string]$SourceNode,
    [Parameter(Mandatory=$true)][string]$DestinationNode
)
Get-ClusterGroup | Where-Object {$_.OwnerNode.Name -eq $SourceNode} | 
    Move-ClusterVirtualMachineRole -Node $DestinationNode
Write-Host "Migration from $SourceNode to $DestinationNode complete." -ForegroundColor Cyan
