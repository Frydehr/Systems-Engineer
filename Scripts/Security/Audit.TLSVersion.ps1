<#
.SYNOPSIS
    Checks for the existence and status of legacy TLS protocols (1.0/1.1) in the registry.
#>
$Protocols = @("TLS 1.0", "TLS 1.1")
$BaseRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"

$Results = foreach ($P in $Protocols) {
    $Path = "$BaseRegistryPath\$P\Server"
    $Enabled = if (Test-Path $Path) { Get-ItemProperty -Path $Path -Name "Enabled" -ErrorAction SilentlyContinue } else { "Not Found (Secure)" }
    
    [PSCustomObject]@{
        Protocol = $P
        Status   = if ($Enabled.Enabled -eq 1) { "Vulnerable (Enabled)" } else { "Secure (Disabled/Missing)" }
    }
}

$Results | Format-Table -AutoSize
