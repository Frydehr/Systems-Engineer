#Use this script to Send a Basic Notification E-mail.		 		#
																	#
#Author: Spencer McConnell											#
																	#
#Don't forget to set VARIABLES 1st! 								#
																	#
#Run "Set-ExecutionPolicy unrestricted" to enable PS scripts.		#
																	#
#Run "$PSVersionTable" to confirm PSVersion 3 or greater.			#
#####################################################################

$SmtpServer = "Server"	

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#
#                        SET VARIABLES ABOVE!                       #

Write-Host "Only Continue if you Set the VARIABLES" -ForegroundColor Magenta
Pause

$EmailFrom = Read-Host -Prompt "Enter the From E-mail Address and press enter"					#<---- Keep as read host to allow script to prompt or replace it with desired value. 
$EmailTo = Read-Host -Prompt "Enter the To E-mail Address and press enter"						#<---- Keep as read host to allow script to prompt or replace it with desired value.
$EmailSubject = Read-Host -Prompt "Enter the subject line then and press enter"					#<---- Keep as read host to allow script to prompt or replace it with desired value.
$EmailBody = Read-Host -Prompt "Enter the body of your message here then press enter to send"	#<---- Keep as read host to allow script to prompt or replace it with desired value.

Write-Host "Sent Message - check e-mail to confirm."

Send-MailMessage -SMTPServer $SmtpServer -to $EmailTo -from $EmailFrom -Subject $EmailSubject -body $EmailBody