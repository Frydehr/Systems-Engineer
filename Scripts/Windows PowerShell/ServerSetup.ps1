#Use this script to Setup a New Windows Server 2016 Image			#			
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

#Set IP and connect to network 
function ip-network {
	Write-host "Setting up network connection......" -ForegroundColor Magenta
	Get-NetAdapter >"C:\NetAdapter.txt"
	Write-host "-------------------------------------------" -ForegroundColor Magenta
	Get-content "C:\NetAdapter.txt"
	Write-host "-------------------------------------------" -ForegroundColor Magenta
	$INT = Read-Host "Type the Name of the Adapter to configure from above. "
	$ETIP = Read-host "Enter the IP Address"						
	$DftGW = Read-host "Enter the Default Gateway"					
#	$DNS = ("192.168.90.5","192.168.90.6")								#<---------------	Confirm DNS
	$DNSsuff = "res.net","hq.usres.com","usres.com","resdev.net,corp.usres.com" 
	New-NetIPAddress -InterfaceAlias $INT -IPAddress $ETIP -PrefixLength 24 -DefaultGateway $DftGW
	Set-DnsClientServerAddress -InterfaceAlias $INT -ServerAddresses $DNS
	Set-DnsClientGlobalSetting -SuffixSearchList @($DNSsuff)
	Del "C:\NetAdapter.txt"
}

#Activate Windows
Function Activate-Windows {
	Write-host "Would you like to Activate Windows?" -ForegroundColor Magenta
	$actos = Read-host "Press 'Y' to change"
	if ($actos -eq "y") {
		Write-host ""
		Write-host "-------------------------------------------" -ForegroundColor Magenta
		Write-host "Which Version of Windows Server Are you Activating?" -ForegroundColor yellow
		Write-host ""
		Write-Host "1.) Windows Server 2016 Standard" -ForegroundColor Green
		Write-Host "2.) Windows Server 2016 Datacenter" -ForegroundColor Green
		Write-Host "3.) Windows Server 2019 Standard" -ForegroundColor Green
		Write-Host "4.) Windows Server 2019 Datacenter" -ForegroundColor Green
		Write-Host ""
		Write-host "-------------------------------------------" -ForegroundColor Magenta
		Write-host ""
		$wsversion = Read-host "Enter the number of your selection above"
	
			if ($wsversion -eq "1") {
				Write-host "Activating Windows Server 2016 Standard....." -ForegroundColor Cyan
				slmgr.vbs /ipk NRPQ8-VRP2Q-PGBRH-C4WTH-PWG32
			}
			elseif ($wsversion -eq "2") {
				Write-host "Activating Windows Server 2016 Datacenter....." -ForegroundColor Cyan
				slmgr.vbs /ipk NHG3D-H4C7Y-Q98CQ-4DW4J-MTD9V
			}
			elseif ($wsversion -eq "3") {
				Write-host "Does the Hyper-V Host have Windows Server 2019 Datacenter OS?" -ForegroundColor yellow
				$HPVHost = Read-host "Press 'y' for yes or anykey for no"
					if ($HPVHost -eq "Y") {
					Write-host "Activating Windows Server 2019 Standard....." -ForegroundColor Cyan
					slmgr.vbs /ipk TNK62-RXVTB-4P47B-2D623-4GF74
					}
					Else {
					Write-host "Activating Windows Server 2019 Standard....." -ForegroundColor Cyan
					slmgr.vbs /ipk N3YKT-C4W69-82X9Y-4VG2K-RM7YQ
					}
			}
			elseif ($wsversion -eq "4") {
				Write-host "Activating Windows Server 2019 Datacenter....." -ForegroundColor Cyan
				slmgr.vbs /ipk CYP7T-9GNXF-8MDWG-DXX3Q-978V7
			}
			else {
				write-host "Incorrect selection!" -foregroundcolor red
				write-host "Moving on Without Activation......" -foregroundcolor yellow
			}
	}
	else {
		write-host "Moving on Without Activation......" -foregroundcolor yellow
		}		
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

#Turning off Firewall - Completed with MDT
function disable-firewall {
Write-host "Turning off Firewall....." -ForegroundColor Cyan
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
}

#Remove Windows Defender
function remove-defender {
Write-host "Removing Windows Defender......." -ForegroundColor Magenta
Remove-WindowsFeature Windows-Defender-Features # <------------(Requires Restart)
}

#Feedback and Diagnostics - Configured by Group Policy "yServers Default Policy -!CD"

#Turn off IE Enhanced Security Configuration - Completed with MDT
function Disable-IEESC {
	Write-host "Disabling IE Enhanced Sercurity Configuration...." -ForegroundColor Green
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

#Set Time Zone - Completed with MDT
function time-zone {
	Write-host "Setting Timezone........" -ForegroundColor Cyan
	Set-Timezone -Name "Pacific Standard Time"
}

#Install Windows Features .Net Framework 3.5
function install-dotnet {
	Write-host "Installing .Net, SMB1,& Telnet......." -ForegroundColor Magenta
	Install-WindowsFeature NET-Framework-Core,FS-SMB1,SNMP-WMI-Provider,Telnet-Client,RSAT-SNMP
}

#Edit SNMP - Configured by Group Policy "yServers SNMP Policy -!CD

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
	robocopy "X:\IT\Infrastructure\ServerBuild\Utilities" C:\Utilities /e /z /r:10 /w:5 /mt /log+:c:\robocopy_Util.log
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
	
#Setup BGinfo
function config-bginfo {
	Write-Host "Linking BGinfo to Startup......." -ForegroundColor Cyan
	Copy-Item "C:\Utilities\BGInfo\Bginfo64.exe - Shortcut.lnk" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" 
}

#Install Cylance
function install-cylance {
	Write-host "Intalling Cylance........" -ForegroundColor Green
	msiexec.exe /i C:\Utilities\Software\CylanceProtect_x64.msi MSIINSTALLPERUSER=1 ALLUSERS=2 /qn PIDKEY=azNUh0ckY24cVVnS7nJEFJl8 LAUNCHAPP=1 /log "C:\Utilities\Logs\CylanceInstall.log"
}

#Install BigFix
function install-bigfix {
	Write-host "Intalling Bigfix........" -ForegroundColor Green
	C:\Utilities\Software\BFClient\setup.exe /S /v /qn
	Write-host "Bigfix Install Complete" -ForegroundColor Yellow
}

function quit-script {
	Write-host "Script Complete!" -ForegroundColor Yellow
	Write-host "Would you like to reboot???..." -ForegroundColor Yellow
	$reboot = read-host "Press 'Y' to restart"
	if ($reboot -eq "y") {
		Write-host "restarting....." -ForegroundColor Yellow
		shutdown -r -f -t 2
		}
	else {
		Write-host "Exiting Script......" -ForegroundColor Yellow
	}
}

function cap-img {
	\\hqmdt01\DeploymentShare$\Scripts\LiteTouch.vbs
}

#Pre-image MDT Script
function mdt-setup {
	enable-winrm
	remove-defender
	install-dotnet
	disable-unwanted
	disable-uac
	disable-tasks
	ps-settings
	disable-hibernate
	util-folder
	config-bginfo
	start-updates
	}

#Pre-image Windows Disk Script
function win-setup {
	create-admin
	enable-rdp
	enable-winrm
	disable-firewall
	remove-defender
	Disable-IEESC
	install-dotnet
	disable-unwanted
	disable-uac
	disable-tasks
	ps-settings
	disable-hibernate
	util-folder
	config-bginfo
	start-updates
}

#Post-image script
function post-image {
	local-admin
	computer-name
	ip-network
	Activate-Windows
	#start-updates
	#install-cylance
	#install-bigfix
}

function main-menu {
Clear-host
	Write-host ""
	Write-host "----------------Main Menu-------------------" -ForegroundColor Magenta
	Write-host "Choose your Selection" -ForegroundColor yellow
	Write-host ""
	Write-Host "1.) Pre-Image Server Setup" -ForegroundColor Green
	Write-Host "2.) Post-Image Server Setup" -ForegroundColor Green
	Write-Host "3.) A la Carte Server Setup Options" -ForegroundColor Green
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
	Write-Host " 4.) Set IP and connect to network" -ForegroundColor Green
	Write-Host " 5.) Activate Windows" -ForegroundColor Green
	Write-Host " 6.) Enable RDP" -ForegroundColor Green
	Write-Host " 7.) Start WinRM to enable Remote Management" -ForegroundColor Green
	Write-Host " 8.) Turning off Firewall" -ForegroundColor Green
	Write-Host " 9.) Remove Windows Defender" -ForegroundColor Green
	Write-Host "10.) Turn off IE Enhanced Security Configuration" -ForegroundColor Green
	Write-Host "11.) Set Time Zone to Pacific" -ForegroundColor Green
	Write-Host "12.) Install Needed Windows Features" -ForegroundColor Green
	Write-Host "13.) Stop and Disable unwanted Services" -ForegroundColor Green
	Write-Host "14.) Disable UAC" -ForegroundColor Green
	Write-Host "15.) Disable default Scheduled Tasks" -ForegroundColor Green
	Write-Host "16.) Set PowerShell Settings" -ForegroundColor Green
	Write-Host "17.) Disable Hibernation" -ForegroundColor Green
	Write-Host "18.) Copy Utilities Folder" -ForegroundColor Green
	Write-Host "19.) Install Windows Updates" -ForegroundColor Green
	Write-Host "20.) Setup BGinfo" -ForegroundColor Green
	Write-Host "21.) Install Cylance" -ForegroundColor Green
	Write-Host "22.) Install BigFix" -ForegroundColor Green
	Write-Host "23.) Capture Image" -ForegroundColor Green
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
			ip-network
			}
		elseif ($UserInput3 -eq '5'){
			Activate-Windows
			}
		elseif ($UserInput3 -eq '6'){
			enable-rdp
			}
		elseif ($UserInput3 -eq '7'){
			enable-winrm
			}
		elseif ($UserInput3 -eq '8'){
			disable-firewall
			}
		elseif ($UserInput3 -eq '9'){
			remove-defender
			}
		elseif ($UserInput3 -eq '10'){
			Disable-IEESC
			}
		elseif ($UserInput3 -eq '11'){
			time-zone
			}
		elseif ($UserInput3 -eq '12'){
			install-dotnet
			}
		elseif ($UserInput3 -eq '13'){
			disable-unwanted
			}
		elseif ($UserInput3 -eq '14'){
			disable-uac
			}
		elseif ($UserInput3 -eq '15'){
			disable-tasks
			}
		elseif ($UserInput3 -eq '16'){
			ps-settings
			}
		elseif ($UserInput3 -eq '17'){
			disable-hibernate
			}
		elseif ($UserInput3 -eq '18'){
			util-folder
			}
		elseif ($UserInput3 -eq '19'){
			start-updates
			}
		elseif ($UserInput3 -eq '20'){
			config-bginfo
			}
		elseif ($UserInput3 -eq '21'){
			install-cylance
			}
		elseif ($UserInput3 -eq '22'){
			install-bigfix
			}
		elseif ($UserInput3 -eq '23'){
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
