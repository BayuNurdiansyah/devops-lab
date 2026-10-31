#!/bin/bash
docker cp files/00-baseline.conf srv-a:/etc/nginx/conf.d/00-baseline.conf
docker exec srv-a nginx -s reload

docker exec srv-b sh -c "printf 'server_tokens on;\nclient_max_body_size 2M;\n' > /etc/nginx/conf.d/00-baseline.conf && nginx -s reload"

docker exec srv-c sh -c "ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && echo Etc/UTC > /etc/timezone"
