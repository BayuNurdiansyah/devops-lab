# 03: Deploy

Lab yang membandingkan deploy in-place dengan release folder + symlink,
termasuk deploy yang gagal di tengah, rollback, dan jebakan OPcache saat
Nginx memakai $document_root (kode lama tetap jalan sampai PHP-FPM di-reload).

Jalankan:
./deploy-inplace.sh v1 && ./deploy-release.sh v1
docker compose up -d --build
./run-lab.sh

Port 8081 in-place, 8082 release ($realpath_root), 8083 release ($document_root).
