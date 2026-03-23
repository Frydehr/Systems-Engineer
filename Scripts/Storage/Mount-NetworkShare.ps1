<#
.SYNOPSIS
    Safely maps a network drive to a specific letter.
#>
param(
    [string]$DriveLetter = "S:",
    [string]$Path = "\\Server\Share"
)

if (Test-Path $Path) {
    if (Test-Path $DriveLetter) { Remove-PSDrive -Name $DriveLetter[0] -Force }
    New-PSDrive -Name $DriveLetter[0] -PSProvider FileSystem -Root $Path -Persist
    Write-Host "Successfully mapped $DriveLetter to $Path" -ForegroundColor Green
} else {
    Write-Error "Path $Path is unreachable. Mapping aborted."
}
