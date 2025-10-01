# 03_create_ou_and_users.ps1
# Run on a Domain Controller or a machine with RSAT and AD PowerShell modules.
# Edit variables as needed.

Import-Module ActiveDirectory

$OUs = @(
    @{Name='IT'; Path='DC=corp,DC=local'},
    @{Name='Users'; Path='DC=corp,DC=local'},
    @{Name='Workstations'; Path='DC=corp,DC=local'}
)

foreach ($ou in $OUs) {
    $dn = "OU=$($ou.Name),$($ou.Path)"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$($ou.Name)'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path
        Write-Host "Created OU: $dn"
    } else {
        Write-Host "OU already exists: $dn"
    }
}

# Create an initial admin user for delegated tasks (NOT Domain Admin)
$UserName = "admin.local"
$DisplayName = "Local Admin"
$PasswordPlain = "ChangeMe!23"   # CHANGE THIS
$SecurePwd = ConvertTo-SecureString $PasswordPlain -AsPlainText -Force
$UserDN = "CN=$UserName,OU=IT,DC=corp,DC=local"

if (-not (Get-ADUser -Filter "SamAccountName -eq '$UserName'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name $DisplayName -SamAccountName $UserName -UserPrincipalName "$UserName@corp.local" `
        -Path "OU=IT,DC=corp,DC=local" -AccountPassword $SecurePwd -Enabled $true -ChangePasswordAtLogon $true
    Write-Host "Created user $UserName"
} else {
    Write-Host "User $UserName already exists"
}
