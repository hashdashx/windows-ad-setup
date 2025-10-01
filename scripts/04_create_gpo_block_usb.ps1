# 04_create_gpo_block_usb.ps1
# Example: create GPO to block USB storage by setting registry policy (RemovableStorageDevices).
# This will create a GPO, set registry values, and link to OU=Workstations.

Import-Module GroupPolicy
Import-Module ActiveDirectory

$GpoName = "GPO_Block_USBStorage"
$Domain = "corp.local"
$OU = "OU=Workstations,DC=corp,DC=local"

# Create GPO if not exists
$gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $GpoName -Comment "Block USB storage devices (example)"
    Write-Host "Created GPO: $GpoName"
} else {
    Write-Host "GPO already exists: $GpoName"
}

# Set registry policy (example) - Prevent installation of removable devices by class (example CLSID)
# NOTE: Many USB-blocking policies are best applied via Administrative Templates or device installation restrictions.
# Below is an example of setting a registry key (per-machine) that can be applied via GPO Preferences.
$RegPath = "HKLM\SOFTWARE\Policies\USBBlockExample"
$Name = "BlockUSB"
$Value = 1

# Use GPO Preferences via PowerShell: create a registry value under the gpo using Set-GPRegistryValue
Set-GPRegistryValue -Name $GpoName -Key $RegPath -ValueName $Name -Type DWord -Value $Value
Write-Host "Set registry value $RegPath\$Name = $Value in GPO $GpoName"

# Link GPO to OU
New-GPLink -Name $GpoName -Target $OU -LinkEnabled Yes
Write-Host "Linked GPO $GpoName to $OU"
