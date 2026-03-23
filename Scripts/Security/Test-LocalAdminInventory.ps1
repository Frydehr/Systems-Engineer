<#
.SYNOPSIS
    Scans remote servers to identify members of the local Administrators group.
#>
param (
    [Parameter(Mandatory=$true)][string[]]$ComputerName
)

foreach ($Computer in $ComputerName) {
    try {
        $Admins = Invoke-Command -ComputerName $Computer -ScriptBlock {
            Get-LocalGroupMember -Group "Administrators" | Select-Object Name, PrincipalSource, @{N='Computer';E={$env:COMPUTERNAME}}
        } -ErrorAction Stop
        $Admins | Export-Csv -Path "$PSScriptRoot\LocalAdminAudit.csv" -Append -NoTypeInformation
    } catch {
        Write-Warning "Failed to reach $Computer"
    }
}
