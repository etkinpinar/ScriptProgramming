################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 2 - Powershell
# DATE OF LAST CHANGE: 2019-05-24
##############################################

Import-Module ActiveDirectory

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Web
#fuction that converts swedish letters
function convertEnglish ($text) {
   $replaceTable = @{"å"="a";"ä"="a";"ö"="o";"é"="e"}
   foreach ($key in $replaceTable.Keys){
        $text = $text -replace $key, $replaceTable[$key]
    }
    return $text
}

#function creates unique username, returns username and user. User is returned because if name is not unique in the role group
#then it changes user's name with a unique name for the user
function createusername ($newuser) {
    $uniquenumber = 1
    $name = $newuser.Name.split(" ")
    $username = ($name[0].Substring(0,2) + $name[1].Substring(0,2)).ToLower()
    $username = convertEnglish $username
    while ($true){
        if (-NOT ((Get-ADUser -Filter {SamAccountName -eq $username}) -eq $null)){  
            $username = $username -replace "[0-9]", ""
            $username = $username + $uniquenumber
            $uniquenumber = $uniquenumber+ 1  
        }else{
            break
        }
    }
    $newuser.name = namecheck $newuser $uniquenumber
    
    return $username, $newuser
}

#function controls uniqueness of the name in the same role group
function namecheck($newuser, $uniquenumber){
    $userlist = Get-ADUser -Filter * -Properties Department
    $uniquenumber = $uniquenumber - 1
    foreach ($user in $userlist){
        #controls their names
        if ($newuser.name -eq $user.name){
            #controls their departments
            if ($newuser.department -eq $user.Department){
                $newuser.name = $newuser.name + $uniquenumber
                break
            }
        }
    }
    return $newuser.name
}
#asks user for a csv file
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = "C:\SHARES\IT\"
    Filter = "CSV (*.csv)|*.csv" }
$null = $FileBrowser.ShowDialog()
$path = $FileBrowser.FileName

#if user does not give a csv file, script will not run
try{
    $content = Import-Csv -Path $path -Delimiter ";" -Encoding UTF7
}
catch{
    exit
}
foreach ($user in $content) {
    
    $passCardNumber = $user.PassCardNumber 
    #checks whether user is already in the current users, pass card number is used for the condition
    if ((Get-ADUser -filter {comment -eq $passCardNumber}) -eq $null){ 
        #list contains return values
        $list = createUsername $user
        $username = $list[0]
        $user = $list[1] 
        $name = $user.Name.split(" ")
        
        $department = $user.Department
        
        #checks existance of the required organisational unit
        if((Get-ADOrganizationalUnit -filter {Name -eq $department}) -eq $null) {
            $OU = @{
                Name = $user.department
            }
            New-ADOrganizationalUnit @OU
        }
        #creates user
        $randPW = [System.Web.Security.Membership]::GeneratePassword(12,1)
        $randPW = $randPW + "0aA"
        $user = @{
            Name = $user.Name
            GivenName = $name[0]
            Surname = $name[1]
            SamAccountName = $username
            Department = $user.Department
            EmailAddress = $user.Email
            Description = $user.Description
            OtherAttributes = @{"comment" = $user.PassCardNumber}
            UserPrincipalName = "$username@script.local"
            AccountPassword = $randPW | ConvertTo-SecureString -AsPlainText -Force
            ChangePasswordAtLogon = 1 
            Enabled = 1
            Path = "OU="+$user.Department+",DC=script,DC=local"
        }
        New-ADUser @user
        #checks the existence of the department group and assigns user's group
        if (-NOT ((Get-ADGroup -filter {Name -eq $department}) -eq $null)){
            Add-ADGroupMember -Identity $department -Members $username
            }
        #if there is no group named as in the text, creates the group
        else{
            $group = @{
                Name = $user.department
                Path = "OU=RoleGroups,DC=script,DC=local"
                GroupScope = "Global"
            }
            New-ADGroup @group
            Add-ADGroupMember -Identity $user.department -Members $username 
        }
        $dir = $FileBrowser.InitialDirectory
        New-Item ($FileBrowser.InitialDirectory+"$username.txt")
        Set-Content -Path $dir"$username.txt" -Value "Login: $username@script.local`r`nPassword: $randPW"
    
    }else{
        Write-Host $user.Name"is already exists with PCN"
    }
}
write-host "Group control begins!"
$userlist = Get-ADUser -Filter * -Properties comment
foreach ($user in $userlist) {
    #finds user in text of user list
    foreach ($user2 in $content) {
        #finds the information for the user, passcardnumber is used to find the user
        if ($user2.PassCardNumber -eq $user.comment) {
            #gets all groups that the user member of
            foreach ($group in (Get-ADPrincipalGroupMembership $user.SamAccountName).name) {
                #gets role group list
                foreach ($role in (Get-ADGroup -filter * -SearchBase "OU=RoleGroups,DC=script,DC=local").Name){
                    #checks whether the group is role group or some other group
                    if ($role -eq $group.ToLower()){
                        #controls whether the group is same as in the text file
                        if(-NOT ($group.ToLower() -eq $user2.Department)){
                            #adds new group membership for the user
                            Add-ADGroupMember -Identity $user2.Department -Members $user.SamAccountName
                            #deletes previous membership
                            Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
                            #changes department in properties of the user
                            Set-ADUser -Identity $user.SamAccountName -Department $user2.Department
                            #changes organizational unit
                            $newOU = $user2.Department
                            Move-ADObject -Identity $user -TargetPath "OU=$newOU,DC=script,DC=local"
                        }
                    }
                }
            }
        }
    }
}

# SIG # Begin signature block
# MIIFWAYJKoZIhvcNAQcCoIIFSTCCBUUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUK0rnNsStamJ2YnI+mTXyV92V
# KXugggL6MIIC9jCCAd6gAwIBAgIQGRr/2QujKJtCHJodGC9IKTANBgkqhkiG9w0B
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
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUvRoSwthG1LLFAjL/yKvTK3yW4akwDQYJKoZI
# hvcNAQEBBQAEggEAcyjcJYnFFUmda7LKQBdJDzh399QKfUh6aMAfPomld1rM4PQs
# CktGxBMgxIc9oBc3VMI1Ieo+FCpaho4+/11Btmm7Rw7sgz0wmqIuwaTZjhKfYH9S
# q1qQhzr8bjLKhH+SbVhADI34ElPIZrplRG0Zb9UHPeUuvDiglIv+yH4RS87jxqI0
# HDc1Q4pTcWUvt3No5SOEvP2AJkGYZvKTpBjjEhnEiWMhJNpds5Y65CJrf/zdsyRL
# cZiqNagsNnkDadQLVtK7EJDP4hc1pbKnQNLFFzBpzbBNr45+mrKkwUHGW9WHI6p8
# UyAX3vDhi57TvpHLUogLZlaTVIfBnAelq9IyHQ==
# SIG # End signature block
