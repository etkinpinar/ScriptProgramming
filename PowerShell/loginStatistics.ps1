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

# SIG # Begin signature block
# MIIFWAYJKoZIhvcNAQcCoIIFSTCCBUUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUY6DWBUn6y9npWcpl/K7awKRr
# ysWgggL6MIIC9jCCAd6gAwIBAgIQGRr/2QujKJtCHJodGC9IKTANBgkqhkiG9w0B
# AQsFADATMREwDwYDVQQDDAhUZXN0Q2VydDAeFw0xOTA1MjgxNjE0MjBaFw0yMDA1
# MjgxNjM0MjBaMBMxETAPBgNVBAMMCFRlc3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF
# AAOCAQ8AMIIBCgKCAQEAxq7cDKyO4xW9Kcaj4N+LsgEhBG/B2JeEvby1vftCJ8b+
# xe2IP+4HLAd4FTqlwYPDJfAQz2/q2zrhMihZqt/nEqAbfjvrOvh8R9fsavIiuiUG
# yV+FfGi46HQQOSI2O1dkwqxE7Sh3ocLKIDE6kMXeJP663+NkDCMvOki/JSdX7iuS
# z6Vm/IoFUswRYQzbRyJv8yvd+DoEGJ7sxzbpLvmTvLNeeneHTfgp3d6o7M+uuhgT
# R9KfVHJDmN7ci1S4qB3MQVjrh7b3jhE71GnRLWqLnSdAXYs7NqtDO5B1bdXi+Inn
# PHo/NRzaRy4sgzvR3oI05suYIfGpB3tjjQ1ef4BvZwIDAQABo0YwRDAOBgNVHQ8B
# Af8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFEiQJQJScIAU
# 0yS37VBdwJ2zFHa5MA0GCSqGSIb3DQEBCwUAA4IBAQC62mwgofGKWe/h8NK9ObKG
# GollakQ7WDsNFlT09EJA3ssk8R4KPJtmxX9QI5cWQSHG1JdEIuREEayhhmdClsoD
# u19Rn2b/vE/EPRlr+TjVs3hmVIZ9NhQL12tcEzT1FD3cPxqNrSkAWvplnefh8BMz
# gj8lJ6fHzX0P38A7XKsWioO37Lyzi9MrAYbR9kvYPjoq83rJi2i7uOwmafclTXfi
# WmKy90EYc53ucxX0OwDUuEdnf+bJw7AdZlcF8MnwlnmdxA3xSOxnTovclEEMOrnf
# Xmz87423Kjukc9AXwr6Ks4QVdWfnUfBlCG1vN+z/hUtWmdtdL2pUJuh4kKbRf1Kk
# MYIByDCCAcQCAQEwJzATMREwDwYDVQQDDAhUZXN0Q2VydAIQGRr/2QujKJtCHJod
# GC9IKTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUBXJ3fk3wUPeUVeCD1HP2pp88Td8wDQYJKoZI
# hvcNAQEBBQAEggEAfVhBvxvQRebOGnBnaet/SVHxwG/FT0L6o7L5UqZY+lgD9uUr
# ccrCBeawigwfoaBZC7SHT8Ql8Kxhe2vvq2apFDBjTcytC2EmrR7/loKVcPdgYxHZ
# CLn5IKr61REWJ5hyWUT8M3JH5ksH/wV9cIwDlY07/hlqg4RwA7f1ir9c0l/lSHFe
# AK7Sm9LEPwPzgmKnu+j0ecqGFa/BlZKVSIpNs1GGmlRuPumSkm47zlGot21Oqw/P
# 1P4g00CXgsktpXhF8kVKXRhFj5OMITCc/yjdGd7HkTM4gKSXlaJK+iPCobI5orqK
# VMcPJyjVehLLUyzqERyRoUMUovq7BD9iO73fRA==
# SIG # End signature block
