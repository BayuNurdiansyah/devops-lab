# 07: Loki + Alloy

Lab: Loki + Grafana Alloy (pengganti Promtail, yang sudah EOL Maret 2026).
Cari error di 3 server tiruan lewat satu query, uji Loki mati saat traffic
jalan, dan lihat apa yang terjadi kalau ip/path/status dijadikan label.

docker compose up -d loki grafana alloy-a alloy-b alloy-c
python3 gen.py --dir logs --rate 10 --duration 120 --bad-after 60
./lq 'sum by (host) (count_over_time({job="nginx"}[1h]))'
