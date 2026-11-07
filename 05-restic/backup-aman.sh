#!/bin/bash
set -u
source "$(dirname "$0")/env.sh"
SRC="$1"
MIN_FILES="${MIN_FILES:-100}"

N=$(find "$SRC" -type f ! -name .manifest.sha256 | wc -l)
if [ "$N" -lt "$MIN_FILES" ]; then
  echo "GAGAL: sumber cuma $N file (minimal $MIN_FILES). Backup dibatalkan."
  exit 1
fi

(cd "$SRC" && find . -type f ! -name .manifest.sha256 -exec sha256sum {} + > .manifest.sha256)

restic backup "$SRC" --tag cron || exit 1
restic check || exit 1

[ -n "${KUMA_PUSH:-}" ] && curl -fsS "$KUMA_PUSH" >/dev/null
echo "Backup OK: $N file"
