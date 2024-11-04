#Use this script to Setup a New Windows 10 Workstation Image		#			
																	#
																	#
#Author: Spencer McConnell											#
																	#
																	#
#Run "$PSVersionTable" to confirm PSVersion 5 or greater.			#
																	#
#####################################################################
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
# ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#
$TimeStamp = get-date -format g
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#functions below
#####################################################################
#Set Local Admin PW Never Expire
function local-admin {
	wmic useraccount where "name='administrator'" set passwordexpires=false
	wmic useraccount where "name='hqadmin'" set passwordexpires=false
}

#Create HQADMIN account
function create-admin {
	write-host "Creating Local Admin Accounts" -ForegroundColor Cyan
	write-host "Please enter HQADMIN password" -ForegroundColor Cyan
	$password = read-host -assecurestring
	new-localuser -name "HQADMIN" -description "Local Admin Account" -password $password -passwordneverexpires
	add-localgroupmember -group "administrators" -member "HQADMIN"
	Write-host "HQADMIN account created....." -foregroundcolor yellow
}

#Change Computer Name
function computer-name { 
	Write-host "Would you like to Change the computer name?" -ForegroundColor Magenta
	$chgNm = Read-host "Press 'Y' to change"
		if ($chgNm -eq "y") {
			$ComputerName = $env:computername
			wmic csproduct get vendor,name,identifyingnumber
			write-host "Enter new computer name: " -foregroundcolor yellow -NoNewline	
			$NewComputerName = read-host 
			Rename-computer -newname $NewComputerName -ComputerName $ComputerName
			write-host "New computer name is now $NewComputerName."
			}
		else {
		write-host "Moving on ......" -foregroundcolor yellow
		}
}

#Activate Windows
Function Activate-Windows {
	Write-host "Would you like to Activate Windows?" -ForegroundColor Magenta
	$actos = Read-host "Press 'Y' to change"
	if ($actos -eq "y") {
				$Wkey = Read-host "Enter Windows 10 Key here with dashes.."
				Write-host "Activating Windows......" -ForegroundColor Cyan
				slmgr.vbs /ipk $Wkey
		}	
	else {
		write-host "Moving on ......" -foregroundcolor yellow
		}		
}

#Opens firewall for File and Print Sharing
function file-print {
	write-host "Setting up File and Print Sharing" -foregroundcolor yellow 
	netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
	write-host "File and Print Sharing Setup Complete" -foregroundcolor yellow
}

#Turns on Remote Registry
function remote-reg {
	$regkeypath = "HKLM:\System\CurrentControlSet\Services"
	Set-ItemProperty -Path $regkeypath\RemoteRegistry -Name "DisplayName" -Value "Remote Registry"
	Set-ItemProperty -Path $regkeypath\RemoteRegistry -Name "Start" -Value 2
}

#Enable RDP - Completed with MDT
function enable-rdp {
	Write-host "Enabling RDP....." -ForegroundColor Magenta
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
}

#Start WinRM to enable Remote Management
function enable-winrm {
	Write-host "Enabling WinRM...." -ForegroundColor Green
	net start Winrm
}

#Remove Windows Defender
function remove-defender {
	Write-host "Removing Windows Defender......." -ForegroundColor Magenta
	Remove-WindowsFeature Windows-Defender-Features # <------------(Requires Restart)
}

#Enables Telnet
function install-telnet {
write-host "Enabling Telnet" -foregroundcolor yellow 
install-windowsfeature "telnet-client" 
write-host "Telnet Enabled" -foregroundcolor yellow
}

#Feedback and Diagnostics - Configured by Group Policy "yServers Default Policy -!CD"

#Set Time Zone - Completed with MDT
function time-zone {
	Write-host "Setting Timezone........" -ForegroundColor Cyan
	Set-Timezone -Name "Pacific Standard Time"
}

#Stop and Disable unwanted Services
function disable-unwanted {
	Write-host "Disabling unwanted Services......" -ForegroundColor Green
	stop-service TapiSrv
	stop-service iphlpsvc
	stop-service WinHttpAutoProxySvc
	stop-service XblAuthManager
	stop-service XblGameSave
	Set-Service TapiSrv -StartupType Disabled
	Set-Service WinHttpAutoProxySvc -StartupType Disabled
	Set-Service XblAuthManager -StartupType Disabled
	Set-Service XblGameSave -StartupType Disabled
}

#Disable UAC <---- Requires restart to go into effect.
function disable-uac { 
	Write-host "Disabling UAC........." -ForegroundColor Cyan
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
	#Other Reg Key settings
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" -Name "DisableStrictNameChecking" -PropertyType "DWord" -Value "1"
}

#Disable default Scheduled Tasks
function disable-tasks {
	Write-host "Disabling default scheduled Tasks.........." -ForegroundColor Magenta
	Get-ScheduledTask ScheduledDefrag | Disable-ScheduledTask
	Get-ScheduledTask XblGameSaveTask | Disable-ScheduledTask
	Get-ScheduledTask XblGameSaveTaskLogon | Disable-ScheduledTask
}

#Powershell Settings
function ps-settings {
	Set-ExecutionPolicy RemoteSigned
	Enable-PSRemoting
}

#Disable Hibernation
function disable-hibernate {
	Write-host "Disabling Hibernation......" -ForegroundColor Green
	powercfg.exe /hibernate off
}

#Copy Utilities Folder
function util-folder {
	Write-host "Copying Utilities folder....." -ForegroundColor Cyan
	Write-host "Please Use your Workstation Login to map the drive" -ForegroundColor yellow
	Write-host "Also Verify DNS is working and you can ping 'HQFS1' before Continuing." -ForegroundColor yellow
	pause
	$UserCredential = Get-Credential
	New-PSDrive -Name X -PSProvider FileSystem -Root \\hqfs1\public -Credential $UserCredential -Persist
	robocopy "X:\IT\Infrastructure\WorkstationBuild\Utilities" C:\Utilities /e /z /r:10 /w:5 /mt /log+:c:\robocopy_Util.log
	net use x: /delete /y
}

#Install Windows Updates
function start-updates {
	Write-host "Installing Windows Updates........" -ForegroundColor Magenta
		# Checking for Microsoft Update Module
		if (!(Get-Module -Name "PSWindowsUpdate"))
	{ 
		#Checking for NuGet Package Provider
		if(!(Get-PackageProvider -Name "NuGet"))
	{	
		Write-host "Setting up Package Provider Connection" -ForegroundColor Magenta
		Install-PackageProvider -Name NuGet -Force
		Update-Module -Name PowerShellGet
	}
	Write-Host "Installing Windows Update Module" -ForegroundColor Magenta
	Install-Module PSWindowsUpdate
	}
	#Installing Updates
	Write-Host "Checking for Windows Updates........" -ForegroundColor Magenta
	Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot
}
	
#Install Cylance
function install-cylance {
	Write-host "Intalling Cylance........" -ForegroundColor Green
	msiexec.exe /i C:\Utilities\Software\CylanceProtect_x64.msi MSIINSTALLPERUSER=1 ALLUSERS=1 /qn PIDKEY=azNUh0ckY24cVVnS7nJEFJl8 LAUNCHAPP=1 /log "C:\Utilities\Logs\CylanceInstall.log"
}

#Quit script function
function quit-script {
	Write-host "Script Complete!" -ForegroundColor Yellow
	Write-host "Would you like to reboot?..." -ForegroundColor Yellow
	$reboot = read-host "Press 'Y' to restart"
	if ($reboot -eq "y") {
		Write-host "restarting....." -ForegroundColor Yellow
		shutdown -r -f -t 2
		}
	else {
		Write-host "Exiting Script......" -ForegroundColor Yellow
	}
}

#Installing Adobe Reader DC
Function Inst-Adobe {
	write-host "Installing Adobe Reader DC: " -foregroundcolor yellow 
	cd "C:\Utilities\Software\"
	.\AcroRdrDC.exe /sPB /rs
	Start-Sleep -Seconds 90
	write-host "Adobe Reader DC install complete: " -foregroundcolor yellow 
}

#Installing Chrome
Function inst-chrome {
	write-host "Installing Google Chrome: " -foregroundcolor yellow 
	cd "C:\Utilities\Software\"
	.\ChromeSetup.exe /silent /install 
	write-host "Google Chrome install complete: " -foregroundcolor green
}

#Installing Firefox
Function inst-firefox {
	write-host "Installing Firefox: " -foregroundcolor yellow 
	cd "C:\Utilities\Software\"
	.\FirefoxInstaller.exe
	write-host "Firefox install complete: " -foregroundcolor green 
}

#Installing Java
Function inst-java {
	write-host "Installing Java - User Interaction Required: " -foregroundcolor yellow 
	cd "C:\Utilities\Software\"
	.\JavaSetup8u251.exe INSTALL_SILENT=Enable AUTO_UPDATE=Enable REBOOT=Disable REMOVEOUTOFDATEJRES=0 /L C:\Utilities\Logs\java.log
	write-host "Java install complete: " -foregroundcolor yellow 
    write-host "Review log "C:\Utilities\Logs\java.log" to confirm success" -foregroundcolor yellow 
}

#Installing Office365
function inst-365 {
write-host "Install process still in Dev. Please download and install for office.com" -foregroundcolor yellow
pause
<#
	write-host "Installing Office 365" -foregroundcolor yellow 
	cd "C:\Utilities\Software\offic365"
	.\setup.exe /configure .\install.xml
	write-host "Office 365 install complete: " -foregroundcolor yellow
#>	
}

#Installing Bigfix
function inst-bigfix {
	write-host "Installing Bigfix" -foregroundcolor yellow 
	cd "C:\Utilities\Software\"
	.\BigFix-BES-Client-9.5.14.73.exe /s
	write-host "Bixfix install complete: " -foregroundcolor yellow 
}

function cap-img {
\\hqmdt01\DeploymentShare$\Scripts\LiteTouch.vbs
}

#Pre-image MDT Script
function mdt-setup {
	file-print
	remote-reg
	time-zone
	remove-defender
	install-telnet
	disable-unwanted
	disable-uac
	disable-tasks
	ps-settings
	disable-hibernate
	util-folder
	Inst-Adobe
	inst-chrome
	inst-firefox
	inst-java
	inst-365
	start-updates
	}

#Pre-image Windows Disk Script
function win-setup {
	create-admin
	file-print
	remote-reg
	time-zone
	enable-rdp
	enable-winrm
	remove-defender
	install-telnet
	time-zone
	disable-unwanted
	disable-uac
	disable-tasks
	ps-settings
	disable-hibernate
	util-folder
	Inst-Adobe
	inst-chrome
	inst-firefox
	inst-java
	inst-365
	start-updates
}

#Post-image script
function post-image {
	local-admin
	computer-name
	Activate-Windows
	start-updates
	install-cylance
	inst-bigfix
}

function main-menu {
Clear-host
	Write-host ""
	Write-host "----------------Main Menu-------------------" -ForegroundColor Magenta
	Write-host "Choose your Selection" -ForegroundColor yellow
	Write-host ""
	Write-Host "1.) Pre-Image Workstation Setup" -ForegroundColor Green
	Write-Host "2.) Post-Image Workstation" -ForegroundColor Green
	Write-Host "3.) A la Carte Workstation Setup Options" -ForegroundColor Green
	Write-Host "Q.) Press 'Q' to quit Script" -ForegroundColor Green
	Write-Host ""
	Write-host "-------------------------------------------" -ForegroundColor Magenta
	Write-host ""
}

function preimage-menu {
Clear-host
	Write-host ""
	Write-host "---------Pre-Image Options Menu-------------" -ForegroundColor Magenta
	Write-host "Choose your Selection" -ForegroundColor yellow
	Write-host ""
	Write-Host "1.) Complete Setup from MDT Install" -ForegroundColor Green
	Write-Host "2.) Complete Setup from OS Disk Install" -ForegroundColor Green
	Write-Host "3.) Capture Image" -ForegroundColor Green
	Write-Host "X.) Go back to Main Menu" -ForegroundColor Green
	Write-Host "Q.) Press 'Q' to quit Script" -ForegroundColor Green
	Write-Host ""
	Write-host "-------------------------------------------" -ForegroundColor Magenta
	Write-host ""
}

function preimage-selection {
	do {
		preimage-menu
		$UserInput2 = read-host "Please make a selection"
		if ($UserInput2 -eq '1'){
			mdt-setup
			}
		elseif ($UserInput2 -eq '2'){
			win-setup
			}
		elseif ($UserInput2 -eq '3'){
			cap-img
			}
		elseif ($UserInput2 -eq 'q'){
			quit-script
			exit
			}
		pause
	}
	until ($UserInput2 -eq 'x')
}

function alacarte-menu {
Clear-host
	Write-host ""
	Write-host "---------A la Carte Options Menu-----------" -ForegroundColor Magenta
	Write-host "Choose your Selection" -ForegroundColor yellow
	Write-host ""
	Write-Host " 1.) Create Local Admin Account." -ForegroundColor Green
	Write-Host " 2.) Set Local Admin PW Never Expire." -ForegroundColor Green
	Write-Host " 3.) Change Computer Name" -ForegroundColor Green
	Write-Host " 4.) Activate Windows" -ForegroundColor Green
	Write-Host " 5.) Enable File and Print settings" -ForegroundColor Green
	Write-Host " 6.) Enable Remote Registry" -ForegroundColor Green
	Write-Host " 7.) Start WinRM to enable Remote Management" -ForegroundColor Green
	Write-Host " 8.) Remove Windows Defender" -ForegroundColor Green
	Write-Host " 9.) Set Time Zone to Pacific" -ForegroundColor Green
	Write-Host "10.) Install Telnet" -ForegroundColor Green
	Write-Host "11.) Stop and Disable unwanted Services" -ForegroundColor Green
	Write-Host "12.) Disable UAC" -ForegroundColor Green
	Write-Host "13.) Disable default Scheduled Tasks" -ForegroundColor Green
	Write-Host "14.) Set PowerShell Settings" -ForegroundColor Green
	Write-Host "15.) Disable Hibernation" -ForegroundColor Green
	Write-Host "16.) Copy Utilities Folder" -ForegroundColor Green
	Write-Host "17.) Install Windows Updates" -ForegroundColor Green
	Write-Host "18.) Install Big Fix" -ForegroundColor Green
	Write-Host "19.) Install Cylance" -ForegroundColor Green
	Write-Host "20.) Install Adobe Reader" -ForegroundColor Green
	Write-Host "21.) Install Chrome" -ForegroundColor Green
	Write-Host "22.) Install FireFox" -ForegroundColor Green
	Write-Host "23.) Install Java" -ForegroundColor Green
	Write-Host "24.) Install Office365" -ForegroundColor Green
	Write-Host "25.) Capture Image" -ForegroundColor Green
	Write-Host " X.) Go back to Main Menu" -ForegroundColor Green
	Write-Host " Q.) Press 'Q' to quit Script" -ForegroundColor Green
	Write-Host ""
	Write-host "-------------------------------------------" -ForegroundColor Magenta
	Write-host ""
}

function alacarte-selection {
	do {
		alacarte-menu
		$UserInput3 = read-host "Please make a selection"
		if ($UserInput3 -eq '1'){
			create-admin
			}
		elseif ($UserInput3 -eq '2'){
			local-admin
			}
		elseif ($UserInput3 -eq '3'){
			computer-name
			}
		elseif ($UserInput3 -eq '4'){
			Activate-Windows
			}
		elseif ($UserInput3 -eq '5'){
			file-print
			}
		elseif ($UserInput3 -eq '6'){
			remote-reg
			}
		elseif ($UserInput3 -eq '7'){
			enable-winrm
			}
		elseif ($UserInput3 -eq '8'){
			remove-defender
			}
		elseif ($UserInput3 -eq '9'){
			time-zone
			}
		elseif ($UserInput3 -eq '10'){
			install-telnet
			}
		elseif ($UserInput3 -eq '11'){
			disable-unwanted
			}
		elseif ($UserInput3 -eq '12'){
			disable-uac
			}
		elseif ($UserInput3 -eq '13'){
			disable-tasks
			}
		elseif ($UserInput3 -eq '14'){
			ps-settings
			}
		elseif ($UserInput3 -eq '15'){
			disable-hibernate
			}
		elseif ($UserInput3 -eq '16'){
			util-folder
			}
		elseif ($UserInput3 -eq '17'){
			start-updates
			}
		elseif ($UserInput3 -eq '18'){
			inst-bigfix
			}
		elseif ($UserInput3 -eq '19'){
			install-cylance
			}
		elseif ($UserInput3 -eq '20'){
			Inst-Adobe
			}
		elseif ($UserInput3 -eq '21'){
			inst-chrome
			}
		elseif ($UserInput3 -eq '22'){
			inst-firefox
			}
		elseif ($UserInput3 -eq '23'){
			inst-java
			}
		elseif ($UserInput3 -eq '24'){
			inst-365
			}
		elseif ($UserInput3 -eq '25'){
			cap-img
			}			
		elseif ($UserInput3 -eq 'q'){
			quit-script
			exit
			}
		pause
	}
	until ($UserInput3 -eq 'x')
}

#function settings above
##################################################################################

#The run script is below
##################################################################################

do {
	main-menu
	$UserInput = read-host "Please make a selection"
	if ($UserInput -eq '1'){
			preimage-selection
			}
	elseif ($UserInput -eq '2'){
			post-image
			}
	elseif ($UserInput -eq '3'){
			alacarte-selection
			}	
	pause
	}
until ($UserInput -eq 'q') 
quit-script
