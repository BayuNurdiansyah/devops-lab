#!/bin/bash
set -e
cd srv/app
CUR=$(basename "$(readlink current)")
PREV=$(ls -1 releases | sort -n | awk -v c="$CUR" '$1<c' | tail -1)
[ -z "$PREV" ] && { echo "tidak ada release sebelumnya"; exit 1; }
ln -sfn releases/$PREV current.tmp
mv -Tf current.tmp current
cd - > /dev/null
echo "$(date +%T.%N | cut -c1-12) rollback ke $PREV" >> deploy.log
