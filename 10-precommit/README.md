# 10: Pre-commit gitleaks

Hook pre-commit dengan gitleaks: menolak commit berisi secret, lalu
tiga cara hook ini terlewati (--no-verify, clone baru tanpa hooksPath,
pola yang tidak dikenal) dan lapis kedua di CI.

Repo percobaan dibuat di work/ dan tidak ikut di-commit.
