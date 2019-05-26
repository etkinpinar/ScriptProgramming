################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 2 - Powershell
# DATE OF LAST CHANGE: 2019-05-26
##############################################

#collects each AD user
$users = (Get-ADGroup -Filter * -SearchBase "OU=RoleGroups,DC=script,DC=local" | Get-ADGroupMember).SamAccountName

#stores all successful logins for each user
$succesfullogins = @{}
foreach ($log in (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID="4768"})) {
    #AD user check
    if ($users.Contains($log.Properties[0].Value)) {
        $succesfullogins[$log.properties[0].Value] = $succesfullogins[$log.properties[0].Value] + 1 
    }
}
#prints out successful login numbers with username
$succesfullogins.GetEnumerator() | Out-String

#finds the day of the oldest unsuccesful login event
$oldestdate = (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID="4771"} -Oldest -MaxEvents 1).TimeCreated.Date
$startdate = $oldestdate
#hash table to store the number of failed login events for each day
$failedperday = @{}
#finds how many failed login attempts was made in each day from oldest log up untill today
while (-NOT ($startdate -eq (Get-Date).addDays(1).Date)) {
    $enddate = $startdate.AddDays(1)
    $filter = @{LogName = "Security"; 
                ID = "4771"; 
                StartTime = $startdate;
                EndTime = $enddate
                }
    $numberoflogs = 0
    foreach ($log in (Get-WinEvent -FilterHashtable $filter -ErrorAction:SilentlyContinue)){
        #checks whether it is an AD user
        if ($users.Contains($log.properties[0].value)){
            $numberoflogs = $numberoflogs + 1
        }
    }
    if (-NOT ($numberoflogs -eq 0)){
        $failedperday[$startdate.ToString("yy/MM/dd")] = $numberoflogs
    }
    $startdate = $enddate
}
#sorts the hashtable and prints it
$failedperday.GetEnumerator() | Sort-Object -Property Value -Descending
Write-Host `n

#stores all unsuccessful logins for each user
$failedlogins = @{}
foreach ($log in (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID="4771"})) {
    if ($users.Contains($log.Properties[0].Value)) {
        $failedlogins[$log.properties[0].Value] = $failedlogins[$log.properties[0].Value] + 1
    }
}
#calculates failed-successful login ratio for users with failed logins
foreach ($key in $failedlogins.Keys){
        $ratio = $failedlogins[$key] / ($succesfullogins[$key]+$failedlogins[$key])
        Write-Host "Ratio for $key : $ratio"
}
