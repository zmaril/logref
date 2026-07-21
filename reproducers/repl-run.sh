#!/usr/bin/env bash
#
# LogRef reproducer driver — Tier 4 replication scenarios (58-61).
#
# Physical/logical replication needs several clusters at once, so unlike the
# Tier 1-2 SQL corpus (run.sh) these scenarios are standalone shell scripts under
# scenarios/. This driver just sets up the shared scratch/capture root and runs
# them in sequence; each script stands up its own clusters, drives its workload,
# copies every cluster's jsonlog into $CAPS as tier4__<scenario>.json, and tears
# everything down. Scoring/dedup against the catalog is left to the measurement
# step (env-coverage.py), exactly as env-run.sh leaves it.
#
# Env:
#   PGBIN     dir with initdb/postgres/psql/pg_basebackup/pg_recvlogical (or PATH)
#   PGLIB     dir with libpq.so (exported as LD_LIBRARY_PATH for a from-source build)
#   OUTDIR    scratch root for clusters + captures (default: mktemp)
#   LOG_LEVEL log_min_messages (default debug1; use debug5 for the widest surface)
#   CAPS      capture dir (default: $OUTDIR/caps)
#   CATALOG   optional; when set, print `wc -l $CAPS/*.json` at the end
#   ONLY      space-separated subset of 58 59 60 61 (default: all)
#
# Postgres refuses to run as root; run this as an unprivileged user.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/lib.sh"
driver_env_setup                 # PGBIN/PGLIB path, initdb check, OUTDIR/CAPS
export PGBIN PGLIB OUTDIR LOG_LEVEL CAPS

ALL="58 59 60 61"
RUN="${ONLY:-$ALL}"

# Give each scenario its own 100-port band, so a lagging teardown in one cannot
# collide with the next scenario's fresh cluster (init_cluster honours PGPORT_NEXT).
band=56000
for n in $RUN; do
    script="$(find "$HERE/scenarios" -maxdepth 1 -name "${n}_*.sh" -print | head -1)"
    if [ -z "$script" ] || [ ! -f "$script" ]; then
        log "no scenario script for '$n'; skipping"
        continue
    fi
    log "### running $(basename "$script") (ports from $band) ###"
    PGPORT_NEXT="$band" bash "$script" || log "  $(basename "$script") exited non-zero (continuing)"
    band=$((band + 100))
done

if [ -n "${CATALOG:-}" ]; then
    log "captures in $CAPS:"
    wc -l "$CAPS"/*.json 2>/dev/null || log "  (no captures produced)"
    log "scoring is the measurement step's job (env-coverage.py); not run here"
else
    log "no CATALOG set; captures left in $CAPS"
fi
log "done. scratch: $OUTDIR"
