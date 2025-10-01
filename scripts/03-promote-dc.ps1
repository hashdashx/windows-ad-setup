# Promote server to Domain Controller with new forest
Import-Module ADDSDeployment
$SafePwd = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force
Install-ADDSForest `
 -DomainName "corp.local" `
 -DomainNetbiosName "CORP" `
 -SafeModeAdministratorPassword $SafePwd `
 -InstallDNS:$true `
 -Force:$true
