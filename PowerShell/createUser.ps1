Import-Module ActiveDirectory

$userlist = Get-LocalUser

$content = Get-Content C:\SHARES\IT\users.csv
for ($i = 1;$i -lt $content.Length; $i++) {
    $userInfo = $content[$i].split(";")
    
    #creates username
    $name = $userInfo[0].split(" ")
    $username = ($name[0].Substring(0,2) + $name[1].Substring(0,2)).ToLower()
    
    #checks whether user is already in the userlist
    foreach ($user in $userlist.Name) {
        $check = $username -eq $user
        if ($check) {
            break    
        }
    }
    #creates user
    if (-NOT $check){
        Add-Type -AssemblyName System.Web
        $randPW = [System.Web.Security.Membership]::GeneratePassword(10,0)
        $user = @{
            Name = $userinfo[0]
            GivenName = $name[0]
            Surname = $name[1]
            SamAccountName = $username
            Department = $userinfo[1]
            EmailAddress = $userinfo[2]
            Description = $userinfo[3]
            EmployeeNumber = $userinfo[4]
            UserPrincipalName = ($username + "@script.local")
            AccountPassword = $randPW | ConvertTo-SecureString -AsPlainText -Force
            ChangePasswordAtLogon = 1 
            Enabled = 1
        }
        New-ADUser @user
        Add-ADGroupMember -Identity $userinfo[1] -Members $username
        New-Item ("C:\SHARES\IT\"+$username+".txt")
        Set-Content ("C:\SHARES\IT\"+$username+".txt") -Value $randPW
    }
    break
}
