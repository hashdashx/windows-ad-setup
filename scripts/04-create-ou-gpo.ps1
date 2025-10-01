# Create OU, Group, User and sample GPO
Import-Module ActiveDirectory
$domain = 'corp.local'
$ouName = 'Employees'
$ouPath = "OU=$ouName,DC=corp,DC=local"

New-ADOrganizationalUnit -Name $ouName -ProtectedFromAccidentalDeletion $true
New-ADGroup -Name 'EDP Users' -GroupScope Global -GroupCategory Security -Path $ouPath
$userPass = ConvertTo-SecureString 'EdpP@ssw0rd!' -AsPlainText -Force
New-ADUser -Name 'EDP User' -SamAccountName 'edp' -AccountPassword $userPass -Enabled $true -Path $ouPath
Add-ADGroupMember -Identity 'EDP Users' -Members 'edp'
