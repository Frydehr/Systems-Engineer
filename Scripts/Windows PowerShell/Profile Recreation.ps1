#Use this to recreate a user profile with a backup of the current profile.	#
																			#
#Author: Spencer McConnell													#
																			#
#############################################################################
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#

#$location=[environment]::GetFolderPath('UserProfile')

#Rename User Folder to User.old
$user_name=Read-Host Prompt 'Input Username'
$user_unc="C:\Users\$user_profile"
	Rename-Item $user_unc "$user_unc.old"

#Declare paths for guid and profile then assign the subdirectory reg keys to the variables reg_guid and reg_list
$reg_location_guid='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileGuid'
$reg_location_list='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'

#Get user guid and sid
	Get-AdUser $user_name | Select-Object -Property ObjectGUID | Set-Variable -Name "user_guid"
	Get-AdUser $user_name | Select-Object -Property SID | Set-Variable -Name "user_sid"

#Match user guid and sid to associated registry key and delete the registry key
	Get-ChildItem $reg_location_guid | Where-Object {$_.Name -like "*$user_guid*"} | Remove-Item
	Get-ChildItem $reg_location_list | Where-Object {$_.Name -like "*$user_sid*"} | Remove-Item