Import-Module ActiveDirectory

#Set settings of research
$InactiveDays = 90

#calculate the afk period
$InactiveDate = (Get-Date).AddDays(-$InactiveDays)

#Research inactive accounts
$InactiveAccounts = Search-ADAccount -AccountInactive -UsersOnly -TimeSpan $InactiveDate

#Print inactive accounts
$InactiveAccounts | Select-Object Name, SamAccountName, Enabled, LastLogonDate
