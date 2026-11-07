export RESTIC_REPOSITORY="$HOME/Dev/riset/devops-lab/05-restic/repo"
export RESTIC_PASSWORD_FILE="$HOME/Dev/riset/devops-lab/05-restic/.restic-pass"

# tunggu MariaDB di container siap (maks ~3 menit), bukan sleep buta
tunggu_db() {
  for i in $(seq 1 90); do
    docker exec "$1" mariadb -uroot -plabroot -e "SELECT 1" >/dev/null 2>&1 && { echo "DB $1 siap"; return 0; }
    sleep 2
  done
  echo "DB $1 TIDAK siap. Log terakhir:"; docker logs --tail 15 "$1"; return 1
}
