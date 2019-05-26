################## METADATA ##################
# NAME: Etkin Pinar
# USERNAME: a18etkpi
# COURSE: Scriptprogramming IT384G - Spring 2019
# ASSIGNMENT: Assignment 2 - Powershell
# DATE OF LAST CHANGE: 2019-05-26
##############################################

#gets all reservations and exclude them from the scope
foreach ($reservation in (Get-DhcpServerv4Reservation -ScopeId 192.168.1.0)) {
    Add-DhcpServerv4ExclusionRange -ScopeId 192.168.1.0 -StartRange $reservation.ipaddress -EndRange $reservation.ipaddress
}

$leases = Get-DhcpServerv4Lease -AllLeases -ScopeId 192.168.1.0 | Sort-Object -Property LeaseExpiryTime 
Get-DhcpServerv4Lease -AllLeases -ScopeId 192.168.1.0 | Sort-Object -Property LeaseExpiryTime 

Write-Host "`nList of Free Addresses"
Get-DhcpServerv4FreeIPAddress -ScopeId 192.168.1.0 -NumAddress 255 -WarningAction:SilentlyContinue

#user chooses which ip address he wants to change
$chosenIP = Read-Host -Prompt "Enter IP address of the active lease you want to change: "

#controls if it is a valid lease
foreach ($lease in $leases) {
    if ($chosenIP -eq $lease.ipaddress){
        $valid = $true
        $clientID = $lease.ClientID
        break
    }
}
#converts it to reserved ip address and excludes it from the scope
if($valid){
    Add-DhcpServerv4Reservation -ScopeId 192.168.1.0 -IPAddress $chosenIP -ClientId $clientID
    Add-DhcpServerv4ExclusionRange -ScopeId 192.168.1.0 -StartRange $chosenIP -EndRange $chosenIP
}
