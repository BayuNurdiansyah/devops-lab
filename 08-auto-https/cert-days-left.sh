#!/bin/bash
# usage: ./cert-days-left.sh host [port]
HOST=$1; PORT=${2:-443}
END=$(echo | openssl s_client -connect "$HOST:$PORT" -servername "$HOST" 2>/dev/null \
      | openssl x509 -noout -enddate | cut -d= -f2)
[ -z "$END" ] && { echo "$HOST: tidak bisa membaca sertifikat"; exit 2; }
SEC=$(( $(date -d "$END" +%s) - $(date +%s) ))
echo "$HOST: sisa $(( SEC / 86400 )) hari ($(( SEC / 60 )) menit), kedaluwarsa $END"
[ $SEC -gt $(( 14 * 86400 )) ]
