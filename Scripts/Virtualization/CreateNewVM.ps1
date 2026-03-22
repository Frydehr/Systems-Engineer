<#
.SYNOPSIS
    Deploys a new Hyper-V VM from a template and adds it to a Failover Cluster.

.DESCRIPTION
    This script automates the VHD copy, VM creation, and cluster registration process.
    Must be run locally on a Hyper-V Cluster Node.

.PARAMETER VMName
    The desired name for the new Virtual Machine.
.PARAMETER RAM
    Memory allocation (e.g., 8GB, 16GB).
.PARAMETER CPU
    Number of virtual processors.
.PARAMETER NetworkSwitch
    The name of the Virtual Switch to attach (Default: "VM External").
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$VMName,

    [Parameter(Mandatory=$false)]
    [string]$RAM = 8GB,

    [Parameter(Mandatory=$false)]
    [int]$CPU = 4,

    [string]$NetworkSwitch = "VM External",
    [string]$BaseImage = "C:\ClusterStorage\Volume216\VMTemplates\SyspreppedVHDsForNewVMs\WS2016Image-SYS-5-22-2020.vhdx"
)

# --- Prerequisites Check ---
if (!(Get-Module -ListAvailable -Name FailoverClusters, Hyper-V)) {
    Write-Error "Required modules (FailoverClusters/Hyper-V) are missing. Please run on a Cluster Host."
    return
}

# --- Storage Logic ---
# Finds the most recently modified Volume in ClusterStorage
$RecentVolume = Get-ChildItem "C:\ClusterStorage" -Directory | 
                Sort-Object LastWriteTime -Descending | 
                Select-Object -First 1

$VMStoragePath = "$($RecentVolume.FullName)\$VMName"
$VhdPath = "$VMStoragePath\$VMName.OS.vhdx"

Write-Host "Target Path: $VMStoragePath" -ForegroundColor Cyan

# --- Execution ---
try {
    # 1. Create Directory & Copy VHD
    if (!(Test-Path $VMStoragePath)) { New-Item -Path $VMStoragePath -ItemType Directory | Out-Null }
    
    Write-Host "Staging OS VHD from template..." -ForegroundColor Green
    Copy-Item $BaseImage -Destination $VhdPath -Force -ErrorAction Stop
    
    # 2. Reset ACLs (Inherit from ClusterStorage)
    $Acl = Get-Acl $VhdPath
    $Acl.SetAccessRuleProtection($false, $true)
    $Acl | Set-Acl $VhdPath

    # 3. Create VM
    Write-Host "Provisioning Hyper-V VM..." -ForegroundColor Magenta
    New-VM -Name $VMName -MemoryStartupBytes $RAM -VHDPath $VhdPath -Path $VMStoragePath -Generation 2 -SwitchName $NetworkSwitch -ErrorAction Stop
    
    Set-VM -Name $VMName -ProcessorCount $CPU -SmartPagingFilePath $VMStoragePath -StaticMemory
    Set-VMProcessor $VMName -CompatibilityForMigrationEnabled $true

    # 4. Add to Cluster
    Write-Host "Registering VM with Cluster..." -ForegroundColor Cyan
    $ClusterResult = Add-ClusterVirtualMachineRole -VirtualMachine $VMName -Name $VMName -ErrorAction SilentlyContinue

    if ($ClusterResult) {
        Write-Host "Success: $VMName is now highly available." -ForegroundColor Green
    } else {
        Write-Warning "VM created but Cluster registration failed. Check if you are in a remote session."
    }
}
catch {
    Write-Error "Deployment failed: $($_.Exception.Message)"
}
