#!/bin/bash
for s in srv-a srv-b srv-c; do docker exec $s baseline-status; done
for p in 8101 8102 8103; do echo "  http :$p -> $(curl -s -m 2 -o /dev/null -w '%{http_code}' localhost:$p)"; done
