#!/usr/bin/env bash
#
# LogRef reproducer — Tier 4 — checkpointer / bgwriter / wal_level control.
#
# Drives the checkpoint + background-writer machinery hard, and walks wal_level
# transitions (and invalid combinations) across restarts, to hit the periodic
# LOG/DEBUG sites and the startup GUC-consistency FATALs that a steady healthy
# cluster never prints.
#
# Target C files:
#   src/backend/postmaster/checkpointer.c ("checkpoint starting", "checkpoint
#       complete", "checkpoints are occurring too frequently", "restartpoint ...")
#   src/backend/postmaster/bgwriter.c     (bgwriter loop DEBUG sites)
#   src/backend/access/transam/xlog.c     (CreateCheckPoint, wal_level /
#       CheckRequiredParameterValues startup checks, "WAL archival (archive_mode=
#       on) requires wal_level ...", "WAL streaming (max_wal_senders > 0) requires
#       wal_level ...")
#   src/backend/postmaster/postmaster.c   (GUC-consistency startup refusal)
#
# Needs log_min_messages=debug5 for the checkpoint/restartpoint DEBUG lines —
# apply_logging_conf pins it (LOG_LEVEL below). Standalone: source lib.sh,
# driver_env_setup, run, collect tier4__checkpoint_bgwriter.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/../lib.sh"
scenario_driver_init                      # LOG_LEVEL=debug5 default, PGBIN/port setup

scenario_checkpoint_bgwriter() {
    local d="$OUTDIR/ckpt/pgdata"
    init_cluster "$d"
    {
        echo "wal_level = replica"
        # Force checkpoints early and often.
        echo "checkpoint_timeout = 30s"       # 30s is the GUC minimum
        echo "max_wal_size = 32MB"             # tiny -> WAL pressure checkpoints
        echo "min_wal_size = 32MB"
        echo "checkpoint_completion_target = 0.1"
        # High warning window so back-to-back checkpoints trip "occurring too
        # frequently" (checkpointer.c).
        echo "checkpoint_warning = 3600s"
        echo "log_checkpoints = on"
        # Aggressive bgwriter so its loop runs and logs at debug5.
        echo "bgwriter_delay = 10ms"
        echo "bgwriter_lru_maxpages = 1000"
        echo "bgwriter_lru_multiplier = 10.0"
        echo "max_wal_senders = 10"
    } >> "$d/postgresql.conf"
    start_cluster "$d"
    local sock=$PGSOCK port=$PGPORT

    # Generate enough WAL to blow past max_wal_size several times, with manual
    # CHECKPOINTs interleaved so two land close together (the frequency warning).
    qpsql "$sock" "$port" <<'SQL'
CREATE TABLE ck (id int, pad text);
INSERT INTO ck SELECT g, repeat('p',400) FROM generate_series(1,120000) g;
CHECKPOINT;
INSERT INTO ck SELECT g, repeat('q',400) FROM generate_series(1,120000) g;
CHECKPOINT;
INSERT INTO ck SELECT g, repeat('r',400) FROM generate_series(1,120000) g;
CHECKPOINT;
CHECKPOINT;
SQL
    sleep 2
    stop_cluster "$d"
    collect tier4 checkpoint_bgwriter "$d"    # <-- the primary cap for this scenario

    # --- wal_level transitions across restart --------------------------------
    # replica -> minimal (needs max_wal_senders=0) -> logical. Each restart runs
    # the wal_level startup path in xlog.c.
    sed -i "s/^wal_level = .*/wal_level = minimal/" "$d/postgresql.conf" 2>/dev/null || \
        echo "wal_level = minimal" >> "$d/postgresql.conf"
    sed -i "s/^max_wal_senders = .*/max_wal_senders = 0/" "$d/postgresql.conf" 2>/dev/null || \
        echo "max_wal_senders = 0" >> "$d/postgresql.conf"
    start_cluster "$d"
    sleep 1
    qpsql "$PGSOCK" "$PGPORT" -c "SELECT current_setting('wal_level'); CHECKPOINT;"
    stop_cluster "$d"
    collect tier4 checkpoint_wal_minimal "$d"

    sed -i "s/^wal_level = .*/wal_level = logical/" "$d/postgresql.conf" 2>/dev/null || \
        echo "wal_level = logical" >> "$d/postgresql.conf"
    start_cluster "$d"
    sleep 1
    qpsql "$PGSOCK" "$PGPORT" -c "SELECT current_setting('wal_level'); CHECKPOINT;"
    stop_cluster "$d"
    collect tier4 checkpoint_wal_logical "$d"

    # --- INVALID combination that FATALs at startup --------------------------
    # wal_level=minimal with max_wal_senders>0 is rejected by
    # CheckRequiredParameterValues / the GUC startup checks. Also turn archive_mode
    # on for good measure (archive_mode=on with wal_level=minimal is rejected too).
    # This boot is EXPECTED to fail; the run continues.
    sed -i "s/^wal_level = .*/wal_level = minimal/" "$d/postgresql.conf" 2>/dev/null || true
    sed -i "s/^max_wal_senders = .*/max_wal_senders = 10/" "$d/postgresql.conf" 2>/dev/null || true
    {
        echo "archive_mode = on"
        echo "archive_command = '/bin/true'"
    } >> "$d/postgresql.conf"
    start_cluster "$d"          # expected to refuse to start
    sleep 1
    stop_cluster "$d"           # no-op if it never came up
    collect tier4 checkpoint_wal_badcombo "$d"
}

run_scenario checkpoint_bgwriter scenario_checkpoint_bgwriter
