<#
.SYNOPSIS
    Pings and tests ports for critical Cloud Endpoints and VPN Gateways.
#>
$Targets = @("10.0.0.4", "portal.azure.com", "outlook.office365.com") # Replace with your VNet IPs

foreach ($Target in $Targets) {
    $Status = Test-NetConnection -ComputerName $Target -Port 443
    if ($Status.TcpTestSucceeded) {
        Write-Host "Connection to $Target (Port 443) is SUCCESSFUL." -ForegroundColor Green
    } else {
        Write-Host "Connection to $Target FAILED. Check VPN Tunnel or NSG Rules." -ForegroundColor Red
    }
}
