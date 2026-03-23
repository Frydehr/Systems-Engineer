<#
.SYNOPSIS
    Measures the response time of a local web service or application endpoint.
#>
param([string]$URL = "http://localhost")

$Time = Measure-Command {
    $Result = Invoke-WebRequest -Uri $URL -UseBasicParsing -ErrorAction SilentlyContinue
}

Write-Host "Service $URL responded in $($Time.TotalMilliseconds)ms" -ForegroundColor Cyan
