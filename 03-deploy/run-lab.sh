#!/bin/bash
cd "$(dirname "$0")"

probe() {
  while true; do
    t=$(date +%T.%N | cut -c1-12)
    for p in 8081 8082 8083; do
      r=$(curl -s -m 1 -w ' %{http_code}' localhost:$p)
      echo "$t $p $r" >> probe.log
    done
    sleep 0.2
  done
}

probe &
PROBE_PID=$!
trap "kill $PROBE_PID 2>/dev/null" EXIT

step() { echo; echo ">>> $(date +%T) $1"; }

sleep 5

step "A: in-place v2 sukses"
./deploy-inplace.sh v2
sleep 10

step "balik ke v1"
./deploy-inplace.sh v1
sleep 10

step "B: in-place v2 gagal di tengah"
./deploy-inplace.sh v2 fail || true
echo "    site sekarang rusak, dibiarkan 20 detik"
sleep 20

step "B: pulihkan manual"
./deploy-inplace.sh v1
sleep 10

step "C: release v2 sukses (sekalian F: amati 8082 vs 8083)"
./deploy-release.sh v2
echo "    tunggu 150 detik supaya kelihatan kapan 8083 ikut pindah"
sleep 150

step "D: release v1 gagal di tengah"
./deploy-release.sh v1 fail || true
sleep 10

step "E: rollback"
./rollback.sh
echo "    tunggu 150 detik lagi untuk lihat 8083 saat rollback"
sleep 150

step "selesai"
