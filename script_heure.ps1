Import-Module Net.Mail

#Installing the FSRM feature

Install-WindowsFeature -Name FS-Resource-Manager, RSAT-FSRM-Mgmt

#   Setting email options
$MHT = @{
  WIN-IFC6RFMAGJHServer = 'WIN-IFC6RFMAGJH.firsttry.com'  
  FromEmailAddress  = 'Amélie.Lotte@firsttry.com'
  AdminEmailAddress = 'Administrateur@firsttry.com'
}

Set-FsrmSetting @MHT

#   Sending a test email to check the setup
$MHT = @{
  ToEmailAddress = 'Administrateur@firsttry.com'
  Confirm        = $false
}
Send-FsrmTestEmail @

#check logins after 22 hours

$AfterHours = Get-Date -Hour 22 -Minute 0 -Second 0
$RecentLogins = Get-WinEvent -FilterHashtable @{
  LogName = 'Security'
  ID = 4624
  StartTime = $AfterHours
}

if ($RecentLogins) {
  $Subject = "Someone has logged after 22h"
  $Body = "This user has logged after 22h :`n"
  $Body += $RecentLogins | ForEach-Object {
    $Event = $_
    $EventMessage = $Event.Message | ConvertFrom-StringData
    $EventMessage['TargetUserName']
  } | Select-Object -Unique

  Send-MailMessage -From 'Amélie.Lotte@firsttry.com' -To 'Administrateur@firsttry.com' -Subject $Subject -Body $Body -SmtpServer 'WIN-IFC6RFMAGJH.firsttry.com'
}