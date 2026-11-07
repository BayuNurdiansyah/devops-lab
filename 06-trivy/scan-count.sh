#!/bin/bash
IMG=$1
OUT="logs/scan-$(echo "$IMG" | tr '/:' '__').json"
./trivy image -q --skip-version-check --scanners vuln --format json "$IMG" > "$OUT" || exit 1
python3 count.py "$OUT" "$IMG"
