# 04: Ansible

Tiga container Ubuntu berperan sebagai server client yang konfigurasinya
sudah beda-beda. Ansible dipakai untuk audit (--check --diff), menyamakan
baseline, mendeteksi perubahan manual, dan membandingkan rollout config
Nginx yang salah: sekaligus ke semua server vs satu per satu dengan
nginx -t dan restore otomatis.

ssh-keygen -t ed25519 -f lab_key -N ''
docker compose up -d --build && ./seed-drift.sh
ansible-playbook site.yml --check --diff
