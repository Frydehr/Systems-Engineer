<#
.SYNOPSIS
    Identifies and restarts stopped 'Automatic' services.
#>
$AutoServices = Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -eq 'Stopped' }

if ($null -eq $AutoServices) {
    Write-Host "All Automatic services are running correctly." -ForegroundColor Green
} else {
    foreach ($Service in $AutoServices) {
        Write-Warning "Service '$($Service.DisplayName)' is stopped. Attempting restart..."
        Start-Service $Service.Name -ErrorAction SilentlyContinue
    }
}
