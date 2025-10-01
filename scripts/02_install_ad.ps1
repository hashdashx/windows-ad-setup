# 02_install_ad.ps1
# Install AD DS role and promote server to first Domain Controller (forest root).
# EDIT THESE VARIABLES BEFORE RUNNING.
$DomainName = "corp.local"
$NetBIOSName = "CORP"
$SafeModePasswordPlain = "P@ssw0rdAdmin!"   # CHANGE THIS to a secure password
$DCStaticIP = "192.168.10.10"               # Set your server IP
$DNSServers = @($DCStaticIP)                # Primary DNS should point to the DC itself

# Convert password to SecureString
$SecurePwd = ConvertTo-SecureString $SafeModePasswordPlain -AsPlainText -Force

Write-Host "Installing Active Directory Domain Services role..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

Write-Host "Promoting server to Domain Controller for domain $DomainName ..."
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetBIOSName `
    -SafeModeAdministratorPassword $SecurePwd `
    -InstallDNS `
    -Force

Write-Host "Promotion command issued. The server will restart automatically when promotion completes."
