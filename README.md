# Projek_KDJK_kel1_P1

# Aplikasi Web "DailyTxt"

## Sekilas Tentang

DailyTXT merupakan aplikasi berbasis web yang dirancang untuk membantu pengguna menulis dan menyimpan catatan harian secara digital. Aplikasi ini memberikan ruang pribadi bagi pengguna untuk mengekspresikan pikiran, perasaan, maupun pengalaman sehari-hari dengan cara yang sederhana dan aman.

Melalui tampilan yang minimalis dan kemudahan akses, DailyTXT mendukung kebiasaan menulis harian sebagai bentuk refleksi diri serta pengelolaan keseharian dalam format modern yang praktis.

## Instalasi

Install Docker dan Docker Compose
```
sudo apt-get update
sudo apt-get install -y docker docker-compose
```

Konfigurasi file docker-compose.yml
```
nano docker-compose.yml
```
```
services:
  dailytxt:
    image: phitux/dailytxt:2.0.0-testing.3
    container_name: dailytxt
    restart: unless-stopped
    volumes:
      - ./data:/data
    environment:
      - SECRET_TOKEN=testingAja
      - INDENT=4
      - ALLOW_REGISTRATION=true
      - ADMIN_PASSWORD=secret123
      - LOGOUT_AFTER_DAYS=40
    ports:
      - 127.0.0.1:8000:80
```

Jalankan Aplikasi
```
sudo docker compose up -d
```

Lalu kunjungi domain web

## Cara Pemakaian

# Pembahasan

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

## Kesimpulan

DailyTxt hadir sebagai aplikasi web ringan yang memudahkan pengguna mencatat hal-hal penting setiap hari tanpa gangguan. Dengan tampilan yang sederhana dan fokus pada teks, DailyTxt membantu menjaga konsistensi menulis dan mendokumentasikan pikiran secara harian. Sayangnya DailyTxt belum mendukung multi-user, tidak ada sistem autentikasi, dan penyimpanan masih bersifat lokal sehingga kurang cocok untuk penggunaan kolaboratif atau jangka panjang.

## Referensi
