Modify the SIP Domain of users in Security Group
================================================

            

If you ever decide to change or add an additional SIP Domain in Lync or Skype for Business you will need to modify the SIP Domain for your users.  It is possible to modify the SIP Domain for one or all users with just a couple of lines of PowerShell
 Code.


This script was created at the request of a client who wanted to be able to modicy the SIP Domain in a more controlled manor.  In their case it was as users were assigned to a specific Security Group.


V1.0 - Friday 8th January 2015 - This script is used to change the SIP domain for users in one or more security groups. This is followed by an Address Book update request and a popup message displaying important notes.


The script also creates a creates and writes the process to a log file


Example usage.
.\Modify-SIPDomain.ps1 -verbose $true

You will be asked to specify one or more Security Groups separated by a comma
You will also be asked for the old domain and the new domain


Additional information is available on my blog post [Modify SIP Domain for Multiple Users](http://lynciverse.blogspot.com/2016/01/modify-sip-domain-for-multiple-users.html).


If you find this upload useful please take a moment to share/rate it.  Comments welcome.


 


Regards


Randy Chapman


[http://lynciverse.com](http://lynciverse.com)


        
    
