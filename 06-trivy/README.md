# 06: Trivy

Lab yang membandingkan hasil scan beberapa base image PHP, memisahkan
temuan mentah dari yang punya versi perbaikan, memindai composer.lock,
mendeteksi secret yang ikut ke image lewat COPY . ., dan memasang gate
di GitHub Actions (blocking untuk dependency, informational untuk base image).

./trivy --version
./scan-count.sh php:8.3-fpm
./make-lock.sh vulnerable && ./trivy fs --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed app
