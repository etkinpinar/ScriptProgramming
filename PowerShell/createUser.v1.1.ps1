Import-Module ActiveDirectory

$userlist = Get-ADUser -Filter *
$content = Import-Csv -Path C:\SHARES\IT\users.csv -Delimiter ";" -Encoding UTF7
#uniquenumber variable is used for making usernames unique
$uniquenumber = 1
foreach ($user in $content) {
    
    #creates username
    $name = $user.Name.split(" ")
    $username = ($name[0].Substring(0,2) + $name[1].Substring(0,2)).ToLower()
    $username = convertEnglish($username)
    #namecheck variable is used to control uniqueness of the username
    $namecheck = $true
    $namer=$user.Name
    #checks whether user is already in the current users
    if ((Get-ADUser -filter {Name -eq $namer}) -eq $null){         
        if ((Get-ADUser -filter {SamAccountName -eq $username}) -eq $null){
            $namecheck = $false
        }else {
            $namecheck = $true
        }
        #if username is used, adds uniquenumber to username
        if ($namecheck){
            $username = $username + $uniquenumber
            $uniquenumber++
        }
        #creates user
        Add-Type -AssemblyName System.Web
        $randPW = [System.Web.Security.Membership]::GeneratePassword(12,2)
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
            Path = "OU=RoleGroups,DC=script,DC=local"
        }
        New-ADUser @user
        #checks the existence of the department group and assigns user's group
        try {
            $group = Get-ADGroup -identity $user.department
            Add-ADGroupMember -Identity $user.department -Members $username
        }
        #if there is no group named as in the text, creates the group
        catch{
            $group = @{
                Name = $user.department
                Path = "OU=RoleGroups,DC=script,DC=local"
                GroupScope = "Global"
            }
            New-ADGroup @group
            Add-ADGroupMember -Identity $user.department -Members $username 
        }
        New-Item ("C:\SHARES\IT\Users\$username.txt")
        Set-Content -Path "C:\SHARES\IT\Users\$username.txt" -Value "Login: $username@script.local`r`nPassword: $randPW"
    
    }
}
$userlist = Get-ADUser -Filter *
foreach ($user in $userlist) {
    #finds the line for the user
    foreach ($user2 in $content) {
        #finds the information for the user
        if ($user2.Name -eq $user.Name) {
            #gets all groups that the user member of
            foreach ($group in (Get-ADPrincipalGroupMembership $user.SamAccountName).name) {
                #checks whether the group is role group or some other group
                foreach ($role in (Get-ADGroup -filter * -SearchBase "OU=RoleGroups,DC=script,DC=local").Name){
                    if ($role -eq $group.ToLower()){
                        #controls whether the group is same as in the text file
                        if(-NOT ($group.ToLower() -eq $user2.Department)){
                            Add-ADGroupMember -Identity $user2.Department -Members $user.SamAccountName
                            Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
                        }
                    }
                }
            }
        }
    }
}

#fuction that converts swedish letters
function convertEnglish ($text) {
   $replaceTable = @{"å"="a";"ä"="a";"ö"="o";"é"="e"}
   foreach ($key in $replaceTable.Keys){
        $text = $text -replace $key, $replaceTable[$key]
    }
    return $text
}