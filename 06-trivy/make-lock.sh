#!/bin/bash
# usage: ./make-lock.sh vulnerable | fixed
case "$1" in
  vulnerable) G=6.5.5;  L=v8.40.0 ;;
  fixed)      G=7.9.2;  L=v10.48.0 ;;
  *) echo "usage: $0 vulnerable|fixed"; exit 1 ;;
esac
cat > app/composer.lock <<LOCK
{
  "packages": [
    {"name": "guzzlehttp/guzzle", "version": "$G"},
    {"name": "laravel/framework", "version": "$L"}
  ],
  "packages-dev": []
}
LOCK
python3 -c "import json;json.load(open('app/composer.lock'))" && echo "app/composer.lock = $1 (guzzle $G, laravel $L)"
