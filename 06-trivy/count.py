import json, sys
path, name = sys.argv[1], sys.argv[2]
data = json.load(open(path))
sev = {"CRITICAL": 0, "HIGH": 0, "MEDIUM": 0, "LOW": 0, "UNKNOWN": 0}
total = fixable_ch = fixable_all = 0
for res in data.get("Results") or []:
    for v in res.get("Vulnerabilities") or []:
        total += 1
        s = v.get("Severity", "UNKNOWN")
        sev[s] = sev.get(s, 0) + 1
        fixed = bool(v.get("FixedVersion"))
        fixable_all += fixed
        if fixed and s in ("CRITICAL", "HIGH"):
            fixable_ch += 1
print("%-28s total=%-4d crit=%-3d high=%-3d | fixable(crit+high)=%-3d fixable(all)=%d" % (name, total, sev["CRITICAL"], sev["HIGH"], fixable_ch, fixable_all))
