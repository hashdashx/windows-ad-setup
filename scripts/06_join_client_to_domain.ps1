# 06_join_client_to_domain.ps1
# Run on a Windows client (PowerShell as Administrator).
# Edit variables, then execute to join domain and restart.

$DomainName = "corp.local"
$DomainAdminUser = "Administrator"
# Prompt for domain admin credentials (secure)
$cred = Get-Credential -Message "Enter domain admin credentials (e.g. CORP\Administrator)"

Write-Host "Joining this machine to domain $DomainName ..."
Add-Computer -DomainName $DomainName -Credential $cred -Restart
