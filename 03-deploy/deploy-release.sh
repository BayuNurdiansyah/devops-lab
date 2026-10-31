#!/bin/bash
set -e
V=$1; FAIL=$2
TS=$(date +%s)
R=srv/app/releases/$TS
echo "$(date +%T.%N | cut -c1-12) release $V mulai ($TS)" >> deploy.log
mkdir -p $R
cp -r source/$V/public $R/                         # "git pull" ke folder baru
sleep 5                                            # "composer install" di folder baru
if [ "$FAIL" = "fail" ]; then
  rm -rf $R
  echo "$(date +%T.%N | cut -c1-12) release $V GAGAL, current tidak disentuh" >> deploy.log
  exit 1
fi
cp -r source/$V/lib $R/
cd srv/app
ln -sfn releases/$TS current.tmp
mv -Tf current.tmp current                         # pindah dalam satu langkah
cd - > /dev/null
echo "$(date +%T.%N | cut -c1-12) release $V aktif ($TS)" >> deploy.log
