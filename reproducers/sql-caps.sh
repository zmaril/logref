#!/usr/bin/env bash
#
# LogRef reproducer driver — per-scenario Tier 2 captures.
#
# run.sh drives every scenario against one cluster and reports a single combined
# Tier 1-2 number. This driver instead captures each Tier 2 scenario (the broad
# crafted-SQL error corpus, scenarios/15-43) *separately*, so env-coverage.py can
# attribute every newly-reproduced site to the scenario that fired it — the same
# per-scenario `<tier>__<scenario>.json` cap shape env-run.sh emits for Tiers 3-4.
#
# It runs one cluster, preloads the baseline scenarios (00-14) for state and
# context, then for each Tier 2 scenario truncates the jsonlog, runs just that
# file, and copies the isolated capture to $OUTDIR/caps/tier2__<name>.json. The
# scenarios share a cluster in file order, exactly as run.sh drives them, so an
# object one scenario creates is visible to the next.
#
# The Tier 2 corpus exercises the installed `contrib` extensions' input and
# validation paths, so the cluster's Postgres must have contrib built and
# installed (base/Dockerfile does this; for a direct build add
# `make -C contrib install` after `make install`).
#
# Env:
#   PGBIN     dir with initdb/postgres/psql (or on PATH)
#   PGLIB     dir with libpq.so (LD_LIBRARY_PATH for a from-source build)
#   OUTDIR    scratch root for the cluster + captures (default: mktemp)
#   LOG_LEVEL log_min_messages (default debug1; measure at debug5)
#
# Postgres refuses to run as root; run this as an unprivileged user.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/lib.sh"

[ -n "${PGBIN:-}" ] && PATH="$PGBIN:$PATH"
[ -n "${PGLIB:-}" ] && export LD_LIBRARY_PATH="$PGLIB:${LD_LIBRARY_PATH:-}"
command -v initdb >/dev/null || { log "initdb not on PATH; set PGBIN"; exit 3; }

OUTDIR="${OUTDIR:-$(mktemp -d)}"
LOG_LEVEL="${LOG_LEVEL:-debug1}"
CAPS="$OUTDIR/caps"
mkdir -p "$CAPS"

d="$OUTDIR/pgdata"
init_cluster "$d"
start_cluster "$d"
sock=$PGSOCK port=$PGPORT
logfile="$(jsonlog_of "$d")"

log "preloading baseline scenarios (00-14)"
for f in "$HERE"/scenarios/0*.sql "$HERE"/scenarios/1[0-4]_*.sql; do
    qpsql "$sock" "$port" -f "$f"
done

log "capturing Tier 2 scenarios (15-43) one at a time"
for f in "$HERE"/scenarios/1[5-9]_*.sql "$HERE"/scenarios/[2-3][0-9]_*.sql \
         "$HERE"/scenarios/4[0-3]_*.sql; do
    [ -e "$f" ] || continue
    name="$(basename "$f" .sql)"
    : > "$logfile"                       # isolate this scenario's emissions
    qpsql "$sock" "$port" -f "$f"
    qpsql "$sock" "$port" -c "SELECT 1"  # flush the last statement's log record
    cp "$logfile" "$CAPS/tier2__${name}.json"
    log "  captured $(wc -l <"$logfile") lines -> tier2__${name}.json"
done

stop_cluster "$d"
log "done. per-scenario Tier 2 caps in $CAPS"
