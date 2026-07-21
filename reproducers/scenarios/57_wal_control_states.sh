#!/usr/bin/env bash
#
# LogRef reproducer — Tier 4 — WAL control-state edges + recovery interruption.
#
# Exercises WAL/pg_control edge call sites that are reachable safely from SQL and
# from a controlled crash-during-recovery, without corrupting anything on disk:
#   - pg_walinspect ERROR sites (bad LSN ranges), when the contrib module builds
#   - the "value too long for restore point" ERROR (xlogfuncs.c)
#   - pg_promote()/promotion functions rejected on a non-standby (xlogfuncs.c)
#   - a crash, a restart into recovery, a SECOND crash mid-recovery, then a final
#     restart -> "database system was interrupted while in recovery at ..."
#     (xlogrecovery.c), which the single-crash recovery scenario never reaches.
#
# Target C files:
#   src/backend/access/transam/xlogfuncs.c     (pg_create_restore_point length
#       check, pg_promote / pg_switch_wal / pg_walfile_name edge errors)
#   src/backend/access/transam/xlogrecovery.c  ("database system was interrupted
#       while in recovery at", "redo done", end-of-recovery)
#   src/backend/access/transam/xlog.c          (pg_switch_wal / control-file)
#   contrib/pg_walinspect/pg_walinspect.c      (bad-range ERROR sites, if present)
#
# Standalone: source lib.sh, driver_env_setup, run, collect. Robust to a missing
# pg_walinspect (logs + continues). set -uo pipefail (no -e) so the crash restarts
# don't abort.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/../lib.sh"
scenario_driver_init                      # LOG_LEVEL=debug5 default, PGBIN/port setup

# hard_crash <datadir> — SIGKILL the postmaster and any surviving backends, the
# way env-run.sh's crash_recovery does, leaving the cluster dirty.
hard_crash() {
    local d="$1" pmpid
    pmpid="$(head -1 "$d/postmaster.pid" 2>/dev/null)"
    if [ -n "$pmpid" ]; then
        kill -9 "$pmpid" 2>/dev/null || true
        pkill -9 -f "postgres.*$d" 2>/dev/null || true
    fi
}

scenario_wal_control_states() {
    local d="$OUTDIR/walctl/pgdata"
    init_cluster "$d"
    echo "wal_level = replica" >> "$d/postgresql.conf"
    echo "max_wal_senders = 10" >> "$d/postgresql.conf"
    start_cluster "$d"
    local sock=$PGSOCK port=$PGPORT

    # --- SQL-reachable WAL/control edge errors -------------------------------
    qpsql "$sock" "$port" <<'SQL'
CREATE TABLE w (id int, pad text);
INSERT INTO w SELECT g, repeat('w',100) FROM generate_series(1,5000) g;
SELECT pg_switch_wal();
SELECT pg_current_wal_lsn(), pg_current_wal_insert_lsn(), pg_current_wal_flush_lsn();
-- over-long restore point name -> ERROR "value too long for restore point".
SELECT pg_create_restore_point(repeat('R',300));
-- promotion functions on a NON-standby -> ERROR "server is not in standby mode".
SELECT pg_promote();
SELECT pg_wal_replay_pause();
SELECT pg_wal_replay_resume();
-- WAL filename edge inputs.
SELECT pg_walfile_name('0/0');
SELECT pg_walfile_name_offset('0/0');
SELECT pg_walfile_name(pg_current_wal_lsn());
CHECKPOINT;
SQL

    # --- pg_walinspect (contrib) bad-range ERROR sites, if it builds ---------
    qpsql "$sock" "$port" -c "CREATE EXTENSION IF NOT EXISTS pg_walinspect;"
    local have_wi
    have_wi="$(psql -h "$sock" -p "$port" -U postgres -d postgres -Atqc \
        "SELECT 1 FROM pg_extension WHERE extname='pg_walinspect'" 2>/dev/null)"
    if [ "$have_wi" = "1" ]; then
        qpsql "$sock" "$port" <<'SQL'
-- end < start, and a start LSN in the future: pg_walinspect's range validation
-- ERRORs ("WAL start LSN must be less than end LSN", "cannot accept future ...").
SELECT * FROM pg_get_wal_records_info('0/0'::pg_lsn, '0/0'::pg_lsn);
SELECT * FROM pg_get_wal_records_info(pg_current_wal_lsn(), '0/1'::pg_lsn);
SELECT * FROM pg_get_wal_stats('FFFFFFFF/FFFFFFFF'::pg_lsn, '0/0'::pg_lsn);
SELECT * FROM pg_get_wal_record_info('0/0'::pg_lsn);
SELECT * FROM pg_get_wal_record_info('FFFFFFFF/FFFFFFFF'::pg_lsn);
SQL
    else
        log "  pg_walinspect not available; skipped its ERROR sites"
    fi
    sleep 1
    stop_cluster "$d" fast
    collect tier4 walctl_sql "$d"

    # --- crash, recover, crash-DURING-recovery, recover ----------------------
    # Round 1: dirty the cluster, then hard-crash. The restart runs crash
    # recovery ("was not properly shut down / redo starts at").
    start_cluster "$d"
    sock=$PGSOCK; port=$PGPORT
    # A big write so the WAL to replay is long enough to still be mid-redo when
    # we crash the recovering server in round 2.
    ( qpsql "$sock" "$port" -c \
        "INSERT INTO w SELECT g, repeat('z',200) FROM generate_series(1,400000) g;" ) &
    sleep 1
    hard_crash "$d"
    sleep 2

    # Round 2: start into recovery, then crash the STARTUP process mid-redo. The
    # next start prints "database system was interrupted while in recovery at ...".
    # start_cluster waits for "ready"; to crash mid-recovery we boot with pg_ctl
    # -W (no wait) and SIGKILL almost immediately.
    pg_ctl -D "$d" -l "$d/server.log" -W start >/dev/null 2>&1 || true
    sleep 1                          # recovery is now in progress (best-effort)
    hard_crash "$d"
    sleep 2

    # Round 3: final clean recovery to a consistent, running cluster.
    start_cluster "$d"
    sleep 1
    qpsql "$PGSOCK" "$PGPORT" -c "SELECT count(*) FROM w;"
    stop_cluster "$d"
    collect tier4 wal_control_states "$d"     # <-- the primary cap for this scenario
}

run_scenario wal_control_states scenario_wal_control_states
