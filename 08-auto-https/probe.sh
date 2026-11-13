#!/bin/bash
cd "$(dirname "$0")"
END=$(( $(date +%s) + 720 ))
while [ $(date +%s) -lt $END ]; do
  t=$(date +%T)
  for p in 8443 8444; do
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 \
      --cacert root.crt --resolve app.local:$p:127.0.0.1 https://app.local:$p/)
    err=$?
    exp=$(echo | openssl s_client -connect 127.0.0.1:$p -servername app.local 2>/dev/null \
      | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2 | awk '{print $3}')
    echo "$t $p http=$code curl_exit=$err cert_expires=$exp" | tee -a logs/probe.log
  done
  sleep 10
done
echo "selesai"
