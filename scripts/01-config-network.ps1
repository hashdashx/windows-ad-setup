# Set static IP for Domain Controller
$nic = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -First 1
New-NetIPAddress -InterfaceIndex $nic.InterfaceIndex -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex $nic.InterfaceIndex -ServerAddresses 192.168.1.10
