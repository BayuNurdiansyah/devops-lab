#!/bin/sh
nginx || echo "nginx gagal start"
exec /usr/sbin/sshd -D -e
