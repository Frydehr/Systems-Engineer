<#
.SYNOPSIS
    Resets a local user profile by backing up the folder and removing registry references.

.DESCRIPTION
    Renames C:\Users\Username to Username.old and deletes the corresponding 
    ProfileGuid and ProfileList keys in the registry to force a fresh login.
    Requires Active Directory module and Local Admin privileges.

.PARAMETER UserName
    The SamAccountName of the user to reset.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
)

# --- Prerequisites ---
if (!(Test-Path "C:\Users\$UserName")) {
    Write-Error "Profile folder for $UserName not found in C:\Users\"
    return
}

# --- Get AD Data ---
try {
    $AdUser = Get-ADUser $UserName -ErrorAction Stop
    $UserSid = $AdUser.SID.Value
    $UserGuid = $AdUser.ObjectGUID.ToString()
}
catch {
    Write-Error "Could not find user $UserName in Active Directory."
    return
}

# --- Step 1: Rename Profile Folder ---
$UserPath = "C:\Users\$UserName"
$BackupPath = "$UserPath.old"

if (Test-Path $BackupPath) {
    Write-Warning "A backup (.old) already exists for this user. Manual cleanup required."
    return
}

try {
    Write-Host "Backing up profile folder to $BackupPath..." -ForegroundColor Cyan
    Rename-Item -Path $UserPath -NewName "$UserName.old" -ErrorAction Stop
}
catch {
    Write-Error "Failed to rename folder. Is the user still logged in?"
    return
}

# --- Step 2: Registry Cleanup ---
$RegGuidPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileGuid"
$RegListPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

Write-Host "Cleaning up Registry entries..." -ForegroundColor Magenta

# Remove from ProfileList (SID)
$SidKey = Join-Path $RegListPath $UserSid
if (Test-Path $SidKey) {
    Remove-Item -Path $SidKey -Recurse -Force
    Write-Host "Removed ProfileList key: $UserSid" -ForegroundColor Green
}

# Remove from ProfileGuid (GUID)
Get-ChildItem $RegGuidPath | Where-Object { $_.Name -like "*$UserGuid*" } | Remove-Item -Force
Write-Host "Removed ProfileGuid reference." -ForegroundColor Green

Write-Host "Profile reset complete. The user will receive a fresh profile on next login." -ForegroundColor Green
