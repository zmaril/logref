#!/usr/bin/env bash
# 58 — physical streaming replication: the full lifecycle (walsender / walreceiver
# / basebackup / recovery / promotion), synchronous replication, a cascading
# standby, and a handful of pg_basebackup variants. These LOG/DEBUG sites live in
# walsender.c, walreceiver.c, basebackup*.c, xlogrecovery.c and startup.c — a
# lone cluster never emits them.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../lib.sh"

repl_begin 58_repl_physical

primary="$SCEN_DIR/primary"
standby="$SCEN_DIR/standby"
cascade="$SCEN_DIR/cascade"

# --- primary + a named physical slot, then some WAL to ship -----------------
repl_primary_up "$primary"
pport="$PGPORT"
qpsql "$PGSOCK" "$pport" <<'SQL'
SELECT pg_create_physical_replication_slot('standby_slot');
CREATE TABLE t (id int PRIMARY KEY, pad text);
INSERT INTO t SELECT g, repeat('x', 64) FROM generate_series(1, 2000) g;
SELECT pg_switch_wal();
CHECKPOINT;
SQL

# --- base-backup a streaming standby off the slot ---------------------------
if repl_standby_up "$primary" "$pport" "$standby" -S standby_slot -C -c fast; then
    sport="$PGPORT"
    repl_wait_streaming "$pport" 1 30 || log "  primary never saw the standby attach"
    # More WAL; the standby replays it (recovery/replay LOGs on the standby).
    qpsql "$(sock_of "$primary")" "$pport" \
        -c "INSERT INTO t SELECT g, repeat('y',64) FROM generate_series(2001,7000) g; CHECKPOINT;"
    repl_wait_catchup "$pport" 20 || log "  standby did not report streaming in time"

    # --- cascading standby: base-backup off the standby, not the primary ----
    if repl_standby_up "$standby" "$sport" "$cascade"; then
        repl_wait_streaming "$sport" 1 20 || log "  cascade never attached to the standby"
    fi

    # --- synchronous replication --------------------------------------------
    # First with the live standby named — commits wait for it and succeed.
    qpsql "$(sock_of "$primary")" "$pport" -c \
        "ALTER SYSTEM SET synchronous_standby_names = '*';"
    pg_ctl -D "$primary" reload >/dev/null 2>&1 || true
    sleep 1
    qpsql "$(sock_of "$primary")" "$pport" \
        -c "SET synchronous_commit=on; INSERT INTO t VALUES (100001,'syncrep');"
    # Then name a standby that will never report — the commit blocks in
    # SyncRepWaitForLSN; a per-statement timeout is the bounded escape so the
    # cancel path fires instead of hanging the driver.
    qpsql "$(sock_of "$primary")" "$pport" -c \
        "ALTER SYSTEM SET synchronous_standby_names = 'FIRST 1 (does_not_exist)';"
    pg_ctl -D "$primary" reload >/dev/null 2>&1 || true
    sleep 1
    qpsql "$(sock_of "$primary")" "$pport" \
        -c "SET statement_timeout='2s'; INSERT INTO t VALUES (100002,'stuck');"
    qpsql "$(sock_of "$primary")" "$pport" -c \
        "ALTER SYSTEM RESET synchronous_standby_names;"
    pg_ctl -D "$primary" reload >/dev/null 2>&1 || true

    # --- promotion: end-of-recovery / promotion LOGs on the standby ---------
    pg_ctl -D "$standby" promote >/dev/null 2>&1 || true
    repl_wait_standby_ready "$standby" "$sport" 15 || true
    qpsql "$(sock_of "$standby")" "$sport" -c "INSERT INTO t VALUES (200001,'promoted');"
    repl_capture 58_repl_physical_standby "$standby"
    [ -d "$cascade" ] && repl_capture 58_repl_physical_cascade "$cascade"
fi

# --- pg_basebackup variants: format / checkpoint / WAL-method edges ---------
# Each fires a distinct code path in basebackup*.c / pg_basebackup.c; all are
# throwaway backups and any failure is tolerated (the log line is the point).
bb="${PGBIN:+$PGBIN/}pg_basebackup"
psock="$(sock_of "$primary")"
"$bb" -h "$psock" -p "$pport" -U postgres -D "$SCEN_DIR/bb_tar"    -Ft  -X fetch -c fast    >/dev/null 2>&1 || true
"$bb" -h "$psock" -p "$pport" -U postgres -D "$SCEN_DIR/bb_spread" -Fp  -X stream -c spread >/dev/null 2>&1 || true
"$bb" -h "$psock" -p "$pport" -U postgres -D "$SCEN_DIR/bb_noslot" -Fp  -X stream --no-slot >/dev/null 2>&1 || true
"$bb" -h "$psock" -p "$pport" -U postgres -D "$SCEN_DIR/bb_manifest" -Fp -X none            >/dev/null 2>&1 || true

repl_capture 58_repl_physical_primary "$primary"
