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

## Referensi
