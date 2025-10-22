#!/bin/bash

# ==========================================
# 🚀 Auto Install Script for DailyTxT (HTTP Only)
# ==========================================
# by: Kelompok 1 KDJK (simplified for no-domain setup)
# ==========================================

echo "=== DailyTxT Auto Installer (HTTP Only) ==="
echo -n "Masukkan ADMIN_PASSWORD: "
read -s admin_pass
echo
echo -n "Masukkan SECRET_TOKEN (kosongkan jika ingin auto-generate): "
read -s secret_token
echo

if [ -z "$secret_token" ]; then
  secret_token=$(openssl rand -base64 32)
  echo "SECRET_TOKEN di-generate otomatis: $secret_token"
fi

echo "Mulai proses instalasi..."
sleep 2

# ------------------------------------------
# 🧩 Update system & install dependencies
# ------------------------------------------
sudo apt update && sudo apt upgrade -y
sudo apt install git ca-certificates curl -y

# Install Docker & Docker Compose (versi resmi)
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Aktifkan Docker
sudo systemctl enable docker
sudo systemctl start docker

# ------------------------------------------
# 📦 Clone & Setup DailyTxT
# ------------------------------------------
cd ~
mkdir -p ~/DailyTxT && cd ~/DailyTxT
git clone https://github.com/PhiTux/DailyTxT.git .
sudo mkdir -p data

# Buat docker-compose.yml
cat <<EOF | sudo tee docker-compose.yml > /dev/null
services:
  dailytxt:
    image: phitux/dailytxt:2.0.0-testing.3
    container_name: dailytxt
    restart: unless-stopped
    volumes:
      - ./data:/data
    environment:
      - SECRET_TOKEN=$secret_token
      - INDENT=4
      - ALLOW_REGISTRATION=true
      - ADMIN_PASSWORD=$admin_pass
      - LOGOUT_AFTER_DAYS=40
    ports:
      - "8000:80"
EOF

# Jalankan container
sudo docker compose up -d

# ------------------------------------------
# ✅ Selesai
# ------------------------------------------
echo "=== Instalasi Selesai ==="
echo "Akses aplikasi di: http://<IP_PUBLIK>:8000"
echo
echo "📜 Informasi Login:"
echo "Admin password: $admin_pass"
echo "Secret token: $secret_token"
echo
echo "📁 Lokasi data: ~/DailyTxT/data"
echo "Untuk menonaktifkan registrasi baru, ubah ALLOW_REGISTRATION=false di docker-compose.yml lalu restart container:"
echo "  sudo docker compose down && sudo docker compose up -d"