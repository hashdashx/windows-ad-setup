# Join a Windows client to the domain
$domain = 'corp.local'
$credential = Get-Credential -Message 'Enter domain admin credentials'
Add-Computer -DomainName $domain -Credential $credential -Restart
