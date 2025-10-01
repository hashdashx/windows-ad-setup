# Panduan Windows Server Active Directory (Portofolio GitHub)

**Ringkasan / Summary (Bahasa Indonesia)**

Repositori ini berisi panduan langkah demi langkah beserta skrip PowerShell untuk:

- Instalasi dan konfigurasi Active Directory Domain Services (AD DS) pada Windows Server (2016/2019/2022).
- Promosi server menjadi Domain Controller (membuat domain baru `corp.local`).
- Membuat Organizational Units (OU) dan Group Policy Objects (GPO).
- Membuat akun pengguna contoh `edp` dan grup `EDP Users`.
- Join komputer client Windows ke domain.
- *(Opsional)* Membuat user Remote Desktop (RDP) agar bisa login via RDP.

---

## Struktur repo (direkomendasikan untuk GitHub)

```
README.md                     <- panduan utama (Bahasa Indonesia)
README.en.md                  <- versi Bahasa Inggris
scripts/
  01-config-network.ps1       <- set IP statis
  02-install-ad.ps1           <- install AD DS role
  03-promote-dc.ps1           <- promote jadi DC
  04-create-ou-gpo.ps1        <- buat OU, grup, user, GPO
  05-join-client.ps1          <- join client ke domain
  06-create-rdp-user.ps1      <- opsional user RDP
changelogs.md
LICENSE
```

---

## Prasyarat

1. Windows Server (2016/2019/2022) dengan akses Administrator.
2. Alamat IP statis untuk server (Domain Controller).
3. DNS diarahkan ke server DC itu sendiri.
4. Komputer client Windows 10/11 di jaringan yang sama.
5. PowerShell dijalankan sebagai Administrator.

---

## Langkah 1 — Konfigurasi IP statis

```powershell
# scripts/01-config-network.ps1
$nic = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -First 1
New-NetIPAddress -InterfaceIndex $nic.InterfaceIndex -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex $nic.InterfaceIndex -ServerAddresses 192.168.1.10
```

---

## Langkah 2 — Instalasi AD DS role

```powershell
# scripts/02-install-ad.ps1
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

---

## Langkah 3 — Promote jadi Domain Controller (buat domain baru)

```powershell
# scripts/03-promote-dc.ps1
Import-Module ADDSDeployment
$SafePwd = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force
Install-ADDSForest `
 -DomainName "corp.local" `
 -DomainNetbiosName "CORP" `
 -SafeModeAdministratorPassword $SafePwd `
 -InstallDNS:$true `
 -Force:$true
```

---

## Langkah 4 — Membuat OU, Group, dan User

```powershell
# scripts/04-create-ou-gpo.ps1
Import-Module ActiveDirectory
$domain = 'corp.local'
$ouName = 'Employees'
$ouPath = "OU=$ouName,DC=corp,DC=local"

New-ADOrganizationalUnit -Name $ouName -ProtectedFromAccidentalDeletion $true
New-ADGroup -Name 'EDP Users' -GroupScope Global -GroupCategory Security -Path $ouPath
$userPass = ConvertTo-SecureString 'EdpP@ssw0rd!' -AsPlainText -Force
New-ADUser -Name 'EDP User' -SamAccountName 'edp' -AccountPassword $userPass -Enabled $true -Path $ouPath
Add-ADGroupMember -Identity 'EDP Users' -Members 'edp'
```

---

## Langkah 5 — Join client Windows ke domain

```powershell
# scripts/05-join-client.ps1
$domain = 'corp.local'
$credential = Get-Credential -Message 'Masukkan kredensial admin domain'
Add-Computer -DomainName $domain -Credential $credential -Restart
```

---

## Langkah 6 — Opsional: Membuat User RDP

```powershell
# scripts/06-create-rdp-user.ps1
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
```

Setelah dijalankan, user `rdpuser` bisa login via RDP.

---

## Ide GPO untuk portofolio

- Enforce password complexity & panjang minimal.
- Lock screen otomatis setelah idle.
- Mapping network drive untuk grup `EDP Users`.
- Membatasi local admin hanya untuk akun tertentu.

---

## Troubleshooting

- `dcdiag /v` → cek kesehatan DC.
- `Get-ADUser edp` → cek user edp.
- `Get-ADUser rdpuser` → cek user RDP.
- `Get-ADGroupMember "Remote Desktop Users"` → cek membership.

---

## Changelog

- 2025-10-01: Commit awal — setup AD DS, OU, GPO, join domain, user RDP opsional.

---

## Lisensi

MIT License
