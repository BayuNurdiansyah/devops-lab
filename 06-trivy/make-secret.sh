#!/bin/bash
# Token PALSU berformat GitHub PAT. Acak, tidak valid, tidak boleh ke-commit.
FAKE="ghp_$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 36)"
printf 'APP_ENV=production\nGITHUB_TOKEN=%s\n' "$FAKE" > app/.env
echo "app/.env dibuat dengan token palsu"
