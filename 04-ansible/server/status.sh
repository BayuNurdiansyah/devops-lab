#!/bin/sh
tz=$(cat /etc/timezone)
body=$(grep -ho 'client_max_body_size [^;]*' /etc/nginx/conf.d/*.conf 2>/dev/null | awk '{print $2}')
tokens=$(grep -ho 'server_tokens [a-z]*' /etc/nginx/conf.d/*.conf 2>/dev/null | awk '{print $2}')
htop=$(command -v htop >/dev/null && echo yes || echo no)
printf '%-6s tz=%-13s upload=%-5s tokens=%-4s htop=%s\n' "$(hostname)" "$tz" "${body:--}" "${tokens:--}" "$htop"
