#!/usr/bin/env bash
#
# LogRef reproducer driver — per-scenario captures for the deep contrib error
# batch (scenarios 62-65). Companion to sql-caps.sh: it stands up one cluster,
# preloads the whole existing corpus (00-43) so the extensions, fixtures and
# multi-AM indexes those files create are in place, then captures each deep
# contrib scenario in isolation via the shared capture_scenario helper. A
# separate baseline capture (00-14) is written so env-coverage.py / the dedupe
# join can subtract the Tier 1 lifecycle sites.
#
# The deep batch drives validation/error paths in the built contrib modules that
# the 40-43 corpus does not reach: data-type array/dimension checks, text-search
# dictionary option validators, trigger-context guards, inspection privilege and
# wrong-page-type guards, amcheck DEBUG tree traversal on valid indexes, WAL LSN
# range validation, postgres_fdw option validators, live-loopback dblink cursor
# and remote-error paths, and pgcrypto salt/cipher errors.
#
# Env: PGBIN/PGLIB (tool path), OUTDIR (scratch root), LOG_LEVEL (measure at
# debug5). Postgres refuses to run as root; run this as an unprivileged user.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/lib.sh"
driver_env_setup

d="$OUTDIR/pgdata"
init_cluster "$d"
start_cluster "$d"
sock=$PGSOCK port=$PGPORT
logfile="$(jsonlog_of "$d")"

log "capturing Tier 1 baseline (00-14)"
: > "$logfile"
for f in "$HERE"/scenarios/0*.sql "$HERE"/scenarios/1[0-4]_*.sql; do
    qpsql "$sock" "$port" -f "$f"
done
qpsql "$sock" "$port" -c "SELECT 1"
cp "$logfile" "$CAPS/baseline.json"

log "preloading existing Tier 2 corpus (15-43) for state"
for f in "$HERE"/scenarios/1[5-9]_*.sql "$HERE"/scenarios/[2-3][0-9]_*.sql \
         "$HERE"/scenarios/4[0-3]_*.sql; do
    [ -e "$f" ] || continue
    qpsql "$sock" "$port" -f "$f"
done

log "capturing deep contrib scenarios (62-65) one at a time"
for f in "$HERE"/scenarios/6[2-5]_*.sql; do
    [ -e "$f" ] || continue
    capture_scenario "$sock" "$port" "$logfile" "$CAPS" "$f"
done

stop_cluster "$d"
log "done. baseline + deep-contrib caps in $CAPS"
