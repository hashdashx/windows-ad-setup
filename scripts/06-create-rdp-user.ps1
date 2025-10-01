# Create optional RDP user
Import-Module ActiveDirectory
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'RemoteUsers'" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name 'RemoteUsers' -ProtectedFromAccidentalDeletion $true
}
$ouPath = "OU=RemoteUsers,DC=corp,DC=local"
$rdpPass = ConvertTo-SecureString 'RdpP@ssw0rd!' -AsPlainText -Force
if (-not (Get-ADUser -Filter "SamAccountName -eq 'rdpuser'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name 'RDP User' -SamAccountName 'rdpuser' -AccountPassword $rdpPass -Enabled $true -Path $ouPath
}
Add-ADGroupMember -Identity 'Remote Desktop Users' -Members 'rdpuser'
