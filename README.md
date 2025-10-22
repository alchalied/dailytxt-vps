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

## Perbandingan dengan Aplikasi Web Sejenis

## Kesimpulan

DailyTxt hadir sebagai aplikasi web ringan yang memudahkan pengguna mencatat hal-hal penting setiap hari tanpa gangguan. Dengan tampilan yang sederhana dan fokus pada teks, DailyTxt membantu menjaga konsistensi menulis dan mendokumentasikan pikiran secara harian. Sayangnya DailyTxt belum mendukung multi-user, tidak ada sistem autentikasi, dan penyimpanan masih bersifat lokal sehingga kurang cocok untuk penggunaan kolaboratif atau jangka panjang.

## Referensi
