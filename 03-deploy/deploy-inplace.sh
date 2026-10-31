#!/bin/bash
set -e
V=$1; FAIL=$2
echo "$(date +%T.%N | cut -c1-12) inplace $V mulai" >> deploy.log
mkdir -p srv/inplace/public srv/inplace/lib
cp source/$V/public/* srv/inplace/public/          # "git pull": kode baru masuk
sleep 5                                            # "composer install" sedang jalan
if [ "$FAIL" = "fail" ]; then
  echo "$(date +%T.%N | cut -c1-12) inplace $V GAGAL" >> deploy.log
  exit 1
fi
cp source/$V/lib/* srv/inplace/lib/                # dependency baru selesai
echo "$(date +%T.%N | cut -c1-12) inplace $V selesai" >> deploy.log
