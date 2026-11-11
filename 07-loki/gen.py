#!/usr/bin/env python3
"""Fake nginx + app logs for 3 'servers'. One of them gets a bad deploy."""
import argparse, os, random, time, uuid
from datetime import datetime

ap = argparse.ArgumentParser()
ap.add_argument("--dir", default="logs")
ap.add_argument("--hosts", default="srv-a,srv-b,srv-c")
ap.add_argument("--rate", type=int, default=10, help="requests/second/host")
ap.add_argument("--duration", type=int, default=120, help="seconds")
ap.add_argument("--bad-host", default="srv-b")
ap.add_argument("--bad-after", type=int, default=60, help="seconds until the bad deploy")
ap.add_argument("--seed", type=int, default=7)
a = ap.parse_args()
random.seed(a.seed)

hosts = a.hosts.split(",")
files = {}
for h in hosts:
    os.makedirs(os.path.join(a.dir, h), exist_ok=True)
    files[h] = (open(os.path.join(a.dir, h, "access.log"), "a", buffering=1),
                open(os.path.join(a.dir, h, "app.log"), "a", buffering=1))

UA = "Mozilla/5.0"
def path():
    r = random.random()
    if r < 0.30: return "/"
    if r < 0.40: return "/login"
    if r < 0.50: return "/static/app.css"
    if r < 0.80: return "/api/orders/%d" % random.randint(1, 99999)
    return "/api/users/%d" % random.randint(1, 99999)

def status(bad):
    r = random.random()
    if bad:
        if r < 0.35: return 500
        if r < 0.45: return 502
    else:
        if r < 0.010: return 500
        if r < 0.015: return 502
        if r < 0.020: return 503
    if r < 0.90: return 200
    if r < 0.95: return 301
    return 404

start = time.time()
sent = 0
while time.time() - start < a.duration:
    tick = time.time()
    for h in hosts:
        acc, app = files[h]
        bad = (h == a.bad_host and tick - start >= a.bad_after)
        for _ in range(a.rate):
            s = status(bad)
            ip = "10.%d.%d.%d" % (random.randint(0, 255), random.randint(0, 255), random.randint(1, 254))
            ts = datetime.now().astimezone().strftime("%d/%b/%Y:%H:%M:%S %z")
            acc.write('%s - - [%s] "GET %s HTTP/1.1" %d %d "-" "%s"\n' % (ip, ts, path(), s, random.randint(200, 9000), UA))
            iso = datetime.now().astimezone().isoformat(timespec="seconds")
            rid = uuid.uuid4().hex[:8]
            if s >= 500:
                msg = 'SQLSTATE[HY000] [2002] Connection refused' if bad else 'upstream timed out'
                app.write('%s level=error msg="%s" request_id=%s\n' % (iso, msg, rid))
            else:
                app.write('%s level=info msg="request ok" request_id=%s duration_ms=%d\n' % (iso, rid, random.randint(3, 220)))
            sent += 1
    time.sleep(max(0, 1 - (time.time() - tick)))
print("done: %d requests across %d hosts" % (sent, len(hosts)))
