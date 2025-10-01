# Active Directory (Windows Server) Deployment Guide — For Portfolio

> English version. For professional portfolio use. Includes ready-to-run PowerShell scripts. Edit variables at top before running.

## Summary
This guide shows the basic steps to:
1. Set up a Windows Server as an Active Directory Domain Controller (AD DS).
2. Configure DNS automatically as part of the DC promotion.
3. Create Organizational Units (OU) and users.
4. Create a Group Policy example (block USB) via PowerShell.
5. Optional: create Remote Desktop (RDP) users and add to Remote Desktop Users group.
6. Join a Windows client to the domain.

> **Warnings & Notes**
- Run PowerShell scripts as **Administrator** on the server.
- Change domain names, passwords and IPs to safe values for your environment.
- These scripts are templates — test in a lab before production use.

---

## Files in the ZIP
- README_ID.md (Indonesian main)
- README_EN.md (this file)
- scripts/
  - 01_set_static_ip.ps1
  - 02_install_ad.ps1
  - 03_create_ou_and_users.ps1
  - 04_create_gpo_block_usb.ps1
  - 05_create_rdp_user.ps1
  - 06_join_client_to_domain.ps1

---

## Quick usage
1. Copy `scripts/02_install_ad.ps1` to the Windows Server.
2. Edit top-of-file variables like `DomainName`, `NetBIOS`, `SafeModePassword`, and static IPs.
3. Run as Administrator:
   ```
   Set-ExecutionPolicy RemoteSigned -Scope Process -Force
   .\scripts\02_install_ad.ps1
   ```
4. After the DC is promoted and restarted, run `03_create_ou_and_users.ps1`.
5. Use `04_create_gpo_block_usb.ps1` for an example GPO (block USB storage).
6. For RDP user, run `05_create_rdp_user.ps1`.
7. To join client machines, run `06_join_client_to_domain.ps1` on the client.

---

## Important variables (edit before execution)
- `$DomainName = "corp.local"`
- `$NetBIOSName = "CORP"`
- `$SafeModePassword = "P@ssw0rdAdmin!"` ← **replace** with a secure password
- `$DCStaticIP = "192.168.10.10"`
- `$DNSPrimary = "192.168.10.10"`

---

## Script explanations
- **01_set_static_ip.ps1**: Optional example of setting static IP via PowerShell.
- **02_install_ad.ps1**: Installs AD DS role and promotes server using `Install-ADDSForest`.
- **03_create_ou_and_users.ps1**: Creates common OUs and an initial admin user.
- **04_create_gpo_block_usb.ps1**: Creates a GPO to block USB storage by registry and links to `Workstations` OU.
- **05_create_rdp_user.ps1**: Creates a domain user for RDP and adds to `Remote Desktop Users`.
- **06_join_client_to_domain.ps1**: Run on Windows client to join the domain.

---

## Security & operational recommendations
1. Test everything in a lab first.
2. Use credential vaults for admin passwords.
3. Backup system state after first DC promotion.
4. Avoid using `corp.local` on public-facing networks without DNS planning.
5. Delegate admin privileges; don't use Domain Admin for daily tasks.

---

## License
Provided for learning and portfolio purposes. Use at your own risk.

