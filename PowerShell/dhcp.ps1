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
#gets dhcp leases
$leases = Get-DhcpServerv4Lease -AllLeases -ScopeId 192.168.1.0 | Sort-Object -Property LeaseExpiryTime 
$leases | Out-String

#gets all free ip addresses in the scope
$freeipaddrs = Get-DhcpServerv4FreeIPAddress -ScopeId 192.168.1.0 -NumAddress 255 -WarningAction:SilentlyContinue
Write-Host "List of Free Addresses"
$freeipaddrs | Out-String
#user chooses which ip address he wants to change
$chosenIP = Read-Host -Prompt "Enter IP address of the active lease you want to change: "
$valid = $false
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
}else{
    Write-Host "IP is not an Active Lease."
}
# SIG # Begin signature block
# MIIFWAYJKoZIhvcNAQcCoIIFSTCCBUUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXdC+QBKZPz4CDtl0NCDAbyYR
# /QOgggL6MIIC9jCCAd6gAwIBAgIQGRr/2QujKJtCHJodGC9IKTANBgkqhkiG9w0B
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
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUQ5Ky2s9hveVYMJb76qfgQBKvbHMwDQYJKoZI
# hvcNAQEBBQAEggEAhKMMLV8zQR0fUDKy9+UU2CQLMkQ1icFTX32z+qZzwCIOQWkC
# fKM0GpMTAifcJd1XkfURCyQ+A+axfr1cSluNTDGUhlEHCfmKV9rMenLKwJTm2hFd
# 6iA1uZoTifDzK8grTnZPbUMTBFOpS6g0VfUqVMDWsYjA1WZGJtGxAM3sQmna1W5S
# 51U7UbNOxnprjvkUpgXGOnsrYgpcYQf5H2tMTYbVcSLLb9sCZUJtlLKSI2sD31vK
# 2Id2B/wEsS8xudUyvMMfgxNQMBEEOahkaNNaTgIVsI2/k2LffyOC06gade+23faY
# oD1mHW32FnjUozwmibvWC5G6zjU5pq/NpvYUZA==
# SIG # End signature block
