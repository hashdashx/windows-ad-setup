# 05_create_rdp_user.ps1
# Create a domain user intended for RDP and add to Remote Desktop Users.
# Enable Remote Desktop on target machines manually or via GPO.

Import-Module ActiveDirectory

$UserName = "rdp.user"
$DisplayName = "RDP User"
$PasswordPlain = "RdpUser!23"   # CHANGE THIS
$SecurePwd = ConvertTo-SecureString $PasswordPlain -AsPlainText -Force
$Path = "OU=Users,DC=corp,DC=local"

if (-not (Get-ADUser -Filter "SamAccountName -eq '$UserName'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name $DisplayName -SamAccountName $UserName -UserPrincipalName "$UserName@corp.local" `
        -Path $Path -AccountPassword $SecurePwd -Enabled $true -ChangePasswordAtLogon $true
    Write-Host "Created user $UserName"
} else {
    Write-Host "User $UserName already exists"
}

# Add to Remote Desktop Users group
Add-ADGroupMember -Identity "Remote Desktop Users" -Members $UserName
Write-Host "Added $UserName to Remote Desktop Users group"
