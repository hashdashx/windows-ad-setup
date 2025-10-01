# Panduan Deploy Active Directory (Windows Server) — Untuk Portofolio

> Versi bahasa Indonesia (utama).  
> Termasuk skrip PowerShell siap pakai. Sesuaikan variabel di bagian atas skrip sebelum dijalankan.

## Ringkasan
Panduan ini menunjukkan langkah-langkah dasar untuk:
1. Menyiapkan server Windows Server sebagai Domain Controller (Active Directory Domain Services / AD DS).
2. Mengatur DNS otomatis (bagian dari promosi DC).
3. Membuat Organizational Units (OU) dan user.
4. Membuat Group Policy (contoh: memblokir USB) via PowerShell.
5. Opsi: membuat user untuk Remote Desktop (RDP) dan menambahkan ke group Remote Desktop Users.
6. Menggabungkan (join) client Windows ke domain.

> **Peringatan & Catatan penting**
- Jalankan skrip PowerShell **dengan hak Administrator** di server Windows.
- Ubah nama domain, password, dan alamat IP ke nilai yang aman/tepat untuk lingkungan Anda.
- Skrip ini memberikan _template_ yang harus diuji di lab sebelum dipakai di produksi.
- Disarankan menggunakan **credential yang kuat** dan mengganti password default segera.

---

## Struktur file dalam ZIP
- README_ID.md (ini)
- README_EN.md (English translation)
- scripts/
  - 01_set_static_ip.ps1
  - 02_install_ad.ps1
  - 03_create_ou_and_users.ps1
  - 04_create_gpo_block_usb.ps1
  - 05_create_rdp_user.ps1
  - 06_join_client_to_domain.ps1

---

## Cara menggunakan (ringkasan cepat)
1. Salin file skrip `scripts/02_install_ad.ps1` ke server Windows Server (Server 2016/2019/2022).
2. Edit variabel pada bagian atas skrip sesuai `DomainName`, `NetBIOS`, `SafeModePassword`, dan static IP jika perlu.
3. Jalankan PowerShell sebagai Administrator:
   ```
   Set-ExecutionPolicy RemoteSigned -Scope Process -Force
   .\scripts\02_install_ad.ps1
   ```
4. Setelah server menjadi Domain Controller dan restart, jalankan `03_create_ou_and_users.ps1` untuk buat OU dan akun awal.
5. Gunakan `04_create_gpo_block_usb.ps1` untuk contoh policy (blok USB storage via registry).
6. Jika perlu user RDP, jalankan `05_create_rdp_user.ps1`.
7. Untuk join client, jalankan `06_join_client_to_domain.ps1` pada mesin client (dengan credential domain admin).

---

## Contoh variabel penting (edit sebelum eksekusi)
Semua skrip memiliki bagian variabel di atas, contohnya:
- `$DomainName = "corp.local"`
- `$NetBIOSName = "CORP"`
- `$SafeModePassword = "P@ssw0rdAdmin!"`  ← **ganti** dengan password kuat
- `$DCStaticIP = "192.168.10.10"`
- `$DNSPrimary = "192.168.10.10"`

---

## Penjelasan singkat tiap skrip
- **01_set_static_ip.ps1**  
  (Opsional) contoh mengatur IP statis via PowerShell (Windows Server). Biasanya Anda atur melalui GUI atau koneksi manajemen.
- **02_install_ad.ps1**  
  Install role AD DS dan mempromosikan server menjadi Domain Controller (Install-ADDSForest).
- **03_create_ou_and_users.ps1**  
  Membuat OU contoh (`IT`, `Users`, `Workstations`) dan user admin awal.
- **04_create_gpo_block_usb.ps1**  
  Membuat GPO yang memblokir storage USB (mengubah registry policy), kemudian link ke OU `Workstations`.
- **05_create_rdp_user.ps1**  
  Membuat user RDP, menambahkan ke grup `Remote Desktop Users`, dan mengaktifkan Remote Desktop pada OU target (instruksi manual/opsional).
- **06_join_client_to_domain.ps1**  
  Skrip untuk dijalankan di client Windows (PowerShell) untuk join domain secara otomatis.

---

## Rekomendasi keamanan & operasional
1. Lakukan semua langkah di **lab** terlebih dahulu.
2. Catat credential admin dan simpan di vault (1Password/Bitwarden).
3. Buat backup system state setelah DC pertama dipromosikan.
4. Jangan gunakan `corp.local` di lingkungan publik tanpa pertimbangan DNS split-horizon.
5. Gunakan GPO dan delegasi akses untuk meminimalkan penggunaan akun Domain Admin sehari-hari.

---

## Lisensi
File ini disertakan untuk keperluan pembelajaran dan portofolio. Gunakan dengan tanggung jawab Anda sendiri.

