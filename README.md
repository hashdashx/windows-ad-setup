# Windows Server Active Directory — Lab & Portfolio

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Panduan ini disiapkan untuk **portfolio GitHub**: bagaimana menyiapkan Windows Server Active Directory, membuat OU, user, Group Policy, serta join client domain.  
> **Bahasa utama:** Indonesia. [English version](README_EN.md) tersedia.

## Isi Repo
- [README_ID.md](README_ID.md) — Dokumentasi utama (Bahasa Indonesia)
- [README_EN.md](README_EN.md) — Versi Inggris
- [scripts/](scripts) — Skrip PowerShell siap edit & jalankan
- [CHANGELOG.md](CHANGELOG.md)
- [LICENSE](LICENSE)

## Screenshot (contoh)
> Tambahkan screenshot hasil lab AD DS di sini agar portfolio lebih menarik.

## Cara Cepat
```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
.\scripts_install_ad.ps1
```

## Catatan
- Gunakan VM untuk uji coba (lab environment).
- Jangan pakai password default, selalu ganti dengan yang kuat.
