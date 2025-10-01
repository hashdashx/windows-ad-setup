# 01_set_static_ip.ps1
# Optional: set static IPv4 address for interface by name.
# Edit variables below to match your environment. Run as Administrator.

$InterfaceName = "Ethernet"
$NewIP = "192.168.10.10"
$PrefixLength = 24
$Gateway = "192.168.10.1"
$DNSServers = @("192.168.10.10","8.8.8.8")

Write-Host "Setting static IP on interface $InterfaceName ..."
Try {
    New-NetIPAddress -InterfaceAlias $InterfaceName -IPAddress $NewIP -PrefixLength $PrefixLength -DefaultGateway $Gateway -ErrorAction Stop
} Catch {
    Write-Warning "New-NetIPAddress failed, trying Set-NetIPAddress..."
    $if = Get-NetAdapter -Name $InterfaceName -ErrorAction Stop
    $index = (Get-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv4).ifIndex
    Set-NetIPAddress -InterfaceIndex $index -IPAddress $NewIP -PrefixLength $PrefixLength -DefaultGateway $Gateway -ErrorAction Stop
}

Set-DnsClientServerAddress -InterfaceAlias $InterfaceName -ServerAddresses $DNSServers
Write-Host "Static IP set. Current IPv4 addresses:"
Get-NetIPAddress -InterfaceAlias $InterfaceName -AddressFamily IPv4 | Format-Table
