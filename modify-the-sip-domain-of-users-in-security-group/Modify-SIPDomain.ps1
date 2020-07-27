#####################################################################################################
# Modify-SIPDomain.ps1
# Author: Randy Chapman http://Lynciverse.com
#
# V1.0 - Friday 8th January 2015 - This script is used to change the SIP domain for users in one or 
# more security groups. This is followed by an Address Book update request and a popup message 
# displaying important notes.
# 
# The script also creates a creates and writes the process to a log file
#
# Example usage.
#
# .\Modify-SIPDomain.ps1 -verbose $true
#
# You will be asked to specify one or more Security Groups separated by a comma
# You will also be asked for the old domain and the new domain
#
# IMPORTANT NOTES: 
# 1. It is important to note that in order for users to communicate with users whose domain has 
# changed, all users must sign out and back in to the client to receive an updated Address Book.
# 
# 2. Users that have not had updates to the address book will see "Presence Unknown" for contacts 
# whose domain has changed.
#
# 3. Users whose domain has changed must sign in with their new SIP Address and enter their AD 
# credentials as DOMAIN\UserName
#
# 4. Users whose domain has changed must recreate previously scheduled Lync & Skype for Business
# meetings
#
# 5. Users whose domain has changed must notify federated contacts that their SIP Address has been 
# updated
#
#####################################################################################################
param($verbose)
Import-Module ActiveDirectory

#Create the Log File
$LogFile = "Modify-SIPDomain-"+(Get-Date -format d.M.yyyy-HHmm)+".txt"
$LogTXT = "Starting operation"
Out-File -FilePath $LogFile -InputObject $LogTXT

# Assigning the Variables
$securityGroup = Read-Host "Enter the name of the Security Group(s) separated by a comma."
$oldDomain = Read-Host "Enter the name of the old domain assigned to the users. e.g. @olddomain.com"
$newDomain = Read-Host "Enter the name of the new domain to assign to the users. e.g. @newdomain.com"
$userList = Get-ADGroupMember -Identity $securityGroup -Recursive | Select SamAccountName

# Writing to the log file
$LogTXT = "Changing the domain name for the following users:"
$LogTXT = "$userList"
$LogTXT = "SIP Domain will be changed from $oldDomain to $newDomain"
Out-File -FilePath $LogFile -InputObject $LogTXT -Append

foreach ($user in $userList)
{
	$sipAddress = $user.SipAddress
	$domainChange = $sipAddress -replace "$oldDomain","$newDomain"
	Set-CsUser -Identity $user.Identity -SipAddress $domainChange

	if ($verbose -eq $true)
	{
		Write-Host -ForegroundColor Blue "User accounts in the $securityGroup Security Group have been assigned the new SIP domain $newDomain."
		Write-Host -ForegroundColor Blue "Users whose domain has changed must sign out and back in with the new SIP address."
	}
	$LogTXT = "User accounts in the $securityGroup Security Group have been assigned the new SIP domain $newDomain."
	Out-File -FilePath $LogFile -InputObject $LogTXT -Append
}

# Updating the Address book
Start-Sleep -Seconds 61
Update-CsAddressBook –verbose
Write-Host -ForegroundColor Blue "All users must sign out of the client and sign back in again to receive the updated Address Book"
$LogTXT = "Request for User replication successfully queued. Replication might take up to five minutes to start."
Out-File -FilePath $LogFile -InputObject $LogTXT -Append

# Display inportant notes message box
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup(
"1. All users must sign out and back in to the client to receive an updated Address Book. 
	
2. Users that have not had updates to the address book will see Presence Unknown for contacts whose SIP Domain has changed.  

3. Users whose domain has changed must sign in with their new SIP Address and enter their AD credentials as DOMAIN\UserName.  
	
4. Users whose domain has changed must recreate previously scheduled Lync & Skype for Business meetings.  
	
5. Users whose domain has changed must notify federated contacts that their SIP Address has been updated.",
10,
"IMPORTANT NOTES",
0x0
)