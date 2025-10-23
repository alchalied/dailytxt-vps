<h1 align="center"><img width="382" height="383" alt="image" src="https://github.com/user-attachments/assets/62217953-6c7b-4bf2-a1ac-f20b06988fff" /></h1>

[Sekilas Tentang](#sekilas-tentang) | [Instalasi](#instalasi) | [Konfigurasi](#konfigurasi) | [Otomatisasi](#otomatisasi) | [Cara Pemakaian](#cara-pemakaian) | [Pembahasan](#pembahasan) | [Referensi](#referensi)
:---:|:---:|:---:|:---:|:---:|:---:|:---:

### Projek KDJK Kelompok 1 (P1)
### Anggota Kelompok :
1. Grasela Anggi Asimima Marbun - G6401231025
2. Adhiya Radhin Fasya - G6401231068
3. Muhammad Abyan Putra Wibowo - G6401231078
4. Muhammad Chalied Al Walid - G6401231114
5. Davina Lydia Alessandra M - G6401231148

# Sekilas Tentang
[`^ kembali ke atas ^`](#)

DailyTXT merupakan aplikasi berbasis web yang dirancang untuk membantu pengguna menulis dan menyimpan catatan harian secara digital. Aplikasi ini memberikan ruang pribadi bagi pengguna untuk mengekspresikan pikiran, perasaan, maupun pengalaman sehari-hari dengan cara yang sederhana dan aman.

Melalui tampilan yang minimalis dan kemudahan akses, DailyTXT mendukung kebiasaan menulis harian sebagai bentuk refleksi diri serta pengelolaan keseharian dalam format modern yang praktis.

# Instalasi
[`^ kembali ke atas ^`](#)

#### Penjelasan Sistem :
- Aplikasi ditulis dengan Svelte (frontend) dan Go (backend).  ￼
- Dirancang untuk dijalankan menggunakan Docker dan Docker Compose.  ￼
- Mendukung sistem arsitektur: AMD64 dan ARM64.
- Nginx sebagai reverse proxy
- Certbot untuk SSL (HTTPS)
- Untuk pengembangan lokal:
  - Go versi minimal: 1.24
  - Node.js versi minimal: 24 (untuk frontend)  ￼
- Data disimpan dalam file JSON, bukan database tradisional, untuk portabilitas maksimal.

#### Proses Instalasi :

1. Login ke Virtual Machine melalui SSH, di sini kami menggunakan Azure.
  ```
  $ ssh azureuser@xx.x.xx.xx
  ```

2. Perbarui paket sistem dan install dependensi utama seperti Docker, Docker Compose, Nginx, dan Certbot.
  ```
  $ sudo apt update && sudo apt upgrade -y
  $ sudo apt install nginx python3-certbot-nginx -y

    # Dari dokumentasi Docker untuk Ubuntu
    # Add Docker's official GPG key:
  $ sudo apt-get update
  $ sudo apt-get install ca-certificates curl
  $ sudo install -m 0755 -d /etc/apt/keyrings
  $ sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  $ sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add the repository to Apt sources:
  $ echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  $ sudo apt-get update

    # Yang benar-benar dibutuhkan adalah docker dan docker compose, jadi tidak harus seperti di bawah ini.
  $ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  ```

3. Aktifkan dan jalankan docker. Walau Docker akan berjalan secara otomatis setelah instalasi, beberapa sistem perlu untuk dijalankan manual.
  ```
  $ sudo systemctl status docker
  $ sudo systemctl start docker
  ```

4. Buat direktori aplikasi DailyTxT.
  ```
  $ mkdir ~/DailyTxT && cd ~/DailyTxT
  ```

5. Git clone repository DailyTxT.
  ```
  $ git clone https://github.com/PhiTux/DailyTxT.git   
  ```

6. Edit file docker-compose.yml.
  ```
  $ nano docker-compose.yml
  ```

  Isi dengan konfigurasi berikut:
  ```
  services:
  dailytxt:
    image: phitux/dailytxt:2.0.0-testing.3
    container_name: dailytxt
    restart: unless-stopped
    volumes:
      - ./data:/data
    environment:
      - SECRET_TOKEN=isi_dengan_token_anda
      - INDENT=4
      - ALLOW_REGISTRATION=true
      - ADMIN_PASSWORD=isi_dengan_password_anda
      - LOGOUT_AFTER_DAYS=40
    ports:
      - "127.0.0.1:8000:80"
  ```
  Image dapat diubah sesuai versi yang ingin digunakan, di sini kami menggunakan versi "2.0.0-testing.3". Informasi lengkapnya dapat dilihat di github DailyTxT.
  Secret_Token dan Admin_Password dapat diisi nilai apapun, contohnya dengan generate token acak dengan OpenSSL:
  ```
  $ openssl rand -base64 32
  ```

7. Jalankan container DailyTxT.
  ```
  $ sudo docker compose up -d
  ```

8. Cek status container.
  ```
  $ sudo docker ps -a
  ```
  pastikan port terdaftar.

Aplikasi sudah dapat diakses pada <PORT_PUBLIK>:8000.

9. Pastikan semua port tersedia. Tambahkan inbound port rule jika belum dibuat pada Azure VM. Buka menu VM -> [Nama VM] -> Networking -> Add inbound port rule, hingga seperti ini:
<img width="1146" height="176" alt="image" src="https://github.com/user-attachments/assets/761b3ae0-a31c-4298-8667-461b39fe6b90" />

10. Konfigurasi Nginx sebagai reverse proxy (untuk HTTPS jika sudah memiliki nama domain).
  ```
  $ sudo nano /etc/nginx/sites-available/dailytxt
  ```

  isi dengan:
  ```
  server {
    listen 80;
    server_name your-domain.com;
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
  }
  ```
  your-domain.com dapat diubah menjadi DNS app.

  simpan file, lalu aktifkan konfigurasi:
  ```
  $ sudo ln -s /etc/nginx/sites-available/dailytxt /etc/nginx/sites-enabled/
  $ sudo nginx -t
  $ sudo systemctl restart nginx
  ```

11. Aktifkan HTTPS dengan Let's Encrypt.
  ```
  $ sudo certbot --nginx -d your-domain.com
  ```

12. Matikan pendaftaran user baru (opsional).
  Setelah membuat sebuah akun, edit file docker-compose.yml
  ```
  - ALLOW_REGISTRATION=false
  ```

  lalu restart container:
  ```
  $ sudo docker-compose down
  $ sudo docker-compose up -d
  ```

# Konfigurasi:
[`^ kembali ke atas ^`](#)

Jika di awal memakai versi 1.x.x dari DailyTxT, ada beberapa hal yang perlu diperhatikan:

Panduan Migrasi DailyTxT v1 → v2
Ringkasan Cepat:
1. Backup dulu seluruh folder data dari versi 1.
2. Gunakan file docker-compose.yml baru dan sesuaikan environment variable-nya.
3. Gunakan volume/folder data lama. Jalankan image versi baru.
4. Hapus cache browser khusus untuk situs DailyTxT agar bisa memuat versi baru.
5. Hapus dan install ulang aplikasi mobile, jika sebelumnya digunakan.
6. Migrasi akan otomatis berjalan saat user lama login pertama kali.

Detail:
- Versi 2 adalah rewrite total, port internal berubah ke 80, dan environment variable juga berubah.
- Kalau hanya ganti tag Docker tanpa update file lain → akan muncul server error.
- Saat container baru dijalankan, server memeriksa apakah ada data lama.
- Jika ada, data lama dipindah ke subfolder old.
- Saat user lama login, sistem otomatis memigrasi data dengan cara:
- Dekripsi data lama pakai algoritma lama.
- Enkripsi ulang pakai algoritma baru.
- Proses cepat (beberapa detik per user, tergantung jumlah data).
- Setelah semua user lama sudah login dan data berhasil dipindahkan, folder old bisa dihapus (manual atau lewat panel admin di DailyTxT).

Tentang Enkripsi & Penyimpanan:
- Menggunakan algoritma ChaCha20-Poly1305 untuk enkripsi.
- Password diubah jadi derived key lewat Argon2id, disimpan di cookie HTTP-only.
- Data tiap user disimpan terenkripsi di server, tanpa database (JSON file) agar mudah dipindah dan awet.
- Jika password diganti, kunci enkripsi akan otomatis disesuaikan.
- Ada backup key sebagai pengganti password jika lupa. Backup key hanya ditampilkan sekali saat dibuat.
- Tidak memakai end-to-end encryption di client, karena fitur pencarian berjalan di server.

# Otomatisasi:
[`^ kembali ke atas ^`](#)

Terdapat cara otomatis untuk menginstall DailyTxT, yaitu dengan menjalankan `script shell` yang akan menjalankan semua perintah instalasi dalam terminal. Kami menyediakan 2 skrip pada repositori ini, yaitu `install_dailytxt.sh` jika sudah memiliki nama domain dan `install_dailytxxt_plain.sh` jika hanya memiliki publik IP. Versi yang terinstall adalah "2.0.0-testing.3".
<img width="1392" height="945" alt="image" src="https://github.com/user-attachments/assets/3af8767c-3cdd-4acd-a288-50f05f980146" />
Note: Untuk `install_dailytxt_plain.sh`, jika saat mengakses <PUBLIK_IP>:8000 tidak berhasil, pastikan protokol yang digunakan adalah HTTPS dan bukan HTTPS.

# Cara Pemakaian
[`^ kembali ke atas ^`](#)

### Fitur-Fitur Utama

1. Catatan Harian(Daily Entries)
2. Keamanan Data dengan Enkripsi
3. Pencarian dan Pengelompokan Catatan
4. Dukungan Lampiran dan Template
5. Tampilan Kalender dan Antarmuka Responsif
6. Portabilitas dan Kendali Penuh Pengguna

### Tampilan Aplikasi Web

1. Register & Login
   ![Register & Login Page](https://github.com/alchalied/dailytxt-vps/blob/main/Screenshots/Register%20%26%20Login%20Page.png)
   Sebelum dapat mengakses catatan, pengguna diarahkan terlebih dahulu ke halaman login yang berfungsi sebagai lapisan keamanan utama.
   Pada halaman ini, pengguna harus memasukkan master password yang telah dibuat sebelumnya. Password ini digunakan untuk mengenkripsi dan mendekripsi seluruh data catatan, sehingga hanya pemilik password yang dapat membaca isi catatan pribadi mereka.
   
3. Halaman Utama (Edit Mode)
   ![Dashboard Edit Mode](https://github.com/alchalied/dailytxt-vps/blob/main/Screenshots/Dashboard%20Edit%20Mode.png)
   Pada halaman utama DailyTxT, pengguna dapat melihat kalender harian di sisi kiri untuk memilih tanggal catatan.
   Di bagian tengah terdapat area editor untuk menulis atau membaca entri, serta tombol upload di sisi kanan untuk menambahkan lampiran.
   Fitur pencarian di bagian bawah kiri memudahkan pengguna menemukan catatan lama berdasarkan kata kunci.
   Tampilan ini membantu pengguna mengelola catatan harian secara visual dan efisien, dengan navigasi sederhana berbasis kalender.
   
5. Halaman Utama (View Mode)
   ![Dashboard View Mode](https://github.com/alchalied/dailytxt-vps/blob/main/Screenshots/Dashboard%20View%20Mode.png)
   Disini pengguna hanya bisa melihat apa saja yang sudah ia tulis beserta detailnya.
   
7. Fitur History
   ![Entries History](https://github.com/alchalied/dailytxt-vps/blob/main/Screenshots/Entries%20History.png)
   DailyTxT menyediakan fitur History of the currently selected day yang memungkinkan pengguna melihat versi catatan terdahulu untuk tanggal tertentu.
   Setiap kali pengguna menyimpan perubahan, sistem secara otomatis menyimpan versi lama tanpa menimpanya, sehingga pengguna bisa melihat atau mengembalikan isi catatan ke versi sebelumnya kapan saja.
   
9. Settings & Statistics
   ![Settings](https://github.com/alchalied/dailytxt-vps/blob/main/Screenshots/Settings.png)
   ![Statistics](https://github.com/alchalied/dailytxt-vps/blob/main/Screenshots/Statistics.png)
   Pada page settings pengguna dapat mengatur appearance sesuai preferensi pengguna, functions (language, timezone, dll), edit & delete tags, membuat template, export data, security (change password, backup codes), dan user account(change & delete username).
   DailyTxt juga menyediakan page statistics yang berisi data statistik semua aktivitas yang pernah dilakukan di dalam aplikasinya.
   
# Pembahasan
[`^ kembali ke atas ^`](#)

## Kelebihan & Kekurangan

### Kelebihan

1. **Sederhana dan Ringan**  
   DailyTxT memiliki antarmuka minimalis tanpa fitur berlebihan, sehingga cepat diakses bahkan di server dengan spesifikasi rendah.

2. **Mendukung Multi-User**  
   Aplikasi ini mendukung beberapa pengguna dengan sistem autentikasi login yang terpisah untuk setiap akun.

3. **Data Tersimpan Lokal (Self-Hosted)**  
   Semua catatan disimpan secara lokal dalam format JSON, memberi kontrol penuh terhadap privasi dan keamanan data pengguna.

4. **Mudah Dikonfigurasi**  
   Pengguna hanya perlu mengatur beberapa variabel lingkungan di `docker-compose.yml` untuk menjalankan aplikasi.

5. **Mendukung Markdown dan Mode Gelap**  
   DailyTxT mendukung format Markdown untuk menulis catatan dengan gaya bebas, serta tersedia opsi mode gelap untuk kenyamanan visual.

### Kekurangan

1. **Tidak Ada Sinkronisasi Cloud Bawaan**  
   Aplikasi belum menyediakan integrasi langsung dengan layanan cloud seperti Google Drive atau Dropbox.

2. **Belum Ada Fitur Kolaborasi Real-Time**  
   Pengguna tidak dapat mengedit catatan secara bersamaan dengan orang lain dalam waktu nyata.

3. **Tampilan Masih Sederhana**  
   Antarmuka fokus pada fungsi, bukan estetika — belum banyak opsi kustomisasi tampilan.

4. **Backup Manual**  
   Karena penyimpanan berbasis file lokal, pengguna harus membuat cadangan data secara manual atau dengan script tambahan.

5. **Belum Mendukung Notifikasi atau Reminder**  
   Aplikasi ini tidak memiliki fitur pengingat otomatis untuk catatan atau tugas tertentu.

## Perbandingan dengan Aplikasi Web Sejenis
[`^ kembali ke atas ^`](#)

### 1. **DailyTxT vs Notion**
DailyTxT lebih ringan dan sederhana dibandingkan Notion yang berfokus pada kolaborasi dan manajemen proyek. Jika Notion menawarkan banyak fitur seperti integrasi database, template, dan kolaborasi real-time, DailyTxT lebih diarahkan untuk penggunaan pribadi tanpa ketergantungan pada layanan cloud. Selain itu, DailyTxT dapat di-host secara mandiri dengan kontrol penuh atas data, sedangkan Notion sepenuhnya bergantung pada server pihak ketiga.

### 2. **DailyTxT vs Joplin**
Kedua aplikasi ini sama-sama mendukung Markdown dan cocok untuk pencatatan pribadi. Namun, DailyTxT lebih mudah dipasang dan dijalankan menggunakan Docker, sementara Joplin memerlukan konfigurasi tambahan untuk sinkronisasi lintas perangkat. Joplin unggul dalam fitur sinkronisasi dan integrasi cloud, sedangkan DailyTxT menonjol karena kesederhanaannya dan kebutuhan server yang ringan.

### 3. **DailyTxT vs Standard Notes**
Standard Notes unggul dalam keamanan karena mendukung enkripsi end-to-end, namun tampilannya lebih minimalis dan beberapa fitur tambahannya berbayar. DailyTxT, di sisi lain, bersifat open-source sepenuhnya dan mudah dikustomisasi sesuai kebutuhan pengguna. Meskipun tidak memiliki enkripsi sekuat Standard Notes, DailyTxT tetap menjaga privasi dengan menyimpan data secara lokal di server pengguna.

### 4. **DailyTxT vs Obsidian**
Obsidian dirancang untuk pengguna yang ingin mengelola catatan lokal secara kompleks dengan konsep knowledge graph. Sementara itu, DailyTxT lebih fokus pada catatan harian yang cepat dan efisien tanpa fitur visualisasi hubungan antar catatan. Obsidian cocok untuk penulis dan peneliti, sedangkan DailyTxT lebih sesuai untuk pengguna yang ingin journaling sederhana berbasis web.

### 5. **DailyTxT vs Simplenote**
Simplenote menawarkan kemudahan akses lintas perangkat melalui akun cloud, namun data disimpan di server pihak ketiga. DailyTxT memberikan kontrol penuh atas penyimpanan data melalui hosting mandiri. Walau Simplenote unggul dalam sinkronisasi dan aksesibilitas, DailyTxT memberikan keunggulan dalam privasi serta kemampuan untuk diatur sesuai kebutuhan pengguna.

## Kesimpulan

**DailyTxt** hadir sebagai aplikasi **web ringan** yang memudahkan pengguna mencatat hal-hal penting setiap hari tanpa gangguan. **Dengan tampilan yang sederhana dan fokus pada teks**, DailyTxt membantu menjaga konsistensi menulis dan mendokumentasikan pikiran secara harian. **Sayangnya DailyTxt belum mendukung multi-user, tidak ada sistem autentikasi, dan penyimpanan masih bersifat lokal sehingga kurang cocok untuk penggunaan kolaboratif atau jangka panjang**.

# Referensi
[`^ kembali ke atas ^`](#)

1. [DailyTxT by PhiTux](https://github.com/PhiTux/DailyTxT) - DailyTxT Docs
2. [Docker & Docker Compose for Ubuntu](https://docs.docker.com/engine/install/ubuntu/) - Docker Docs
