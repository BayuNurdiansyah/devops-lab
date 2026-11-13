# 08: Auto HTTPS

Nginx dengan sertifikat yang dipasang sekali vs Caddy yang memperpanjang
sendiri, memakai CA lokal Caddy dengan sertifikat berumur 5 menit supaya
siklus perpanjangan bisa diamati dalam 12 menit.

docker compose up -d caddy
(lihat panduan untuk menyalin sertifikat ke nginx)
./probe.sh
