#!/bin/bash
set -u
source "$(dirname "$0")/env.sh"
SRC="$(cd "$1" && pwd)"
T=$(mktemp -d)
START=$(date +%s)

if ! restic restore latest --path "$SRC" --target "$T" >/dev/null; then
  echo "DRILL FAILED: restore error"; rm -rf "$T"; exit 1
fi
M=$(find "$T" -name .manifest.sha256 | head -1)
if [ -z "$M" ]; then
  echo "DRILL FAILED: manifest missing from restore"; rm -rf "$T"; exit 1
fi
if ! (cd "$(dirname "$M")" && sha256sum -c .manifest.sha256 --quiet); then
  echo "DRILL FAILED: checksum mismatch"; rm -rf "$T"; exit 1
fi

DUR=$(( $(date +%s) - START ))
rm -rf "$T"
[ -n "${KUMA_PUSH_DRILL:-}" ] && curl -fsS "$KUMA_PUSH_DRILL" >/dev/null
echo "DRILL OK: restore + verification in ${DUR}s"
