#!/bin/bash
source "$(dirname "$0")/env.sh"
restic backup "$1" --tag cron
echo "Backup selesai"
exit 0
