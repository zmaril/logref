#!/usr/bin/env bash
#
# LogRef reproducer — Tier 4 — hot-standby recovery conflicts + promotion.
#
# Stands up a primary and a streaming hot standby, then deliberately provokes
# recovery conflicts on the standby (feedback off, zero standby delay) by running
# a long query there while the primary vacuums/drops/locks the same relation —
# then promotes the standby. This reaches the recovery-conflict cancellation
# sites and the walreceiver connect/disconnect + promotion sites that the
# existing replication scenario (which never contends) does not.
#
# Target C files:
#   src/backend/storage/ipc/standby.c        (ResolveRecoveryConflictWithSnapshot
#       / WithLock / WithBufferPin, "canceling statement due to conflict with
#       recovery", the recovery-conflict LOG/DETAIL sites)
#   src/backend/tcop/postgres.c              (conflict-driven statement cancel /
#       ERRCODE_T_R_SERIALIZATION_FAILURE report)
#   src/backend/replication/walreceiver.c    ("started streaming WAL from
#       primary", "replication terminated", disconnect logging)
#   src/backend/access/transam/xlogrecovery.c ("received promote request",
#       end-of-recovery / new-timeline on promotion)
#   src/backend/replication/walsender.c      (primary side of the stream)
#
# Standalone: source lib.sh, driver_env_setup, run, collect. The standby cluster
# is created by pg_basebackup (not init_cluster), mirroring env-run.sh's
# scenario_replication.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/../lib.sh"
scenario_driver_init                      # LOG_LEVEL=debug5 default, PGBIN/port setup

scenario_standby_conflict() {
    local root="$OUTDIR/sbconf"
    local p="$root/primary" s="$root/standby"

    # --- primary -------------------------------------------------------------
    init_cluster "$p"
    {
        echo "wal_level = replica"
        echo "max_wal_senders = 10"
        echo "max_replication_slots = 10"
        echo "hot_standby = on"
    } >> "$p/postgresql.conf"
    echo "host replication postgres 127.0.0.1/32 trust" >> "$p/pg_hba.conf"
    echo "local replication postgres trust" >> "$p/pg_hba.conf"
    start_cluster "$p"
    local psock=$PGSOCK pport=$PGPORT

    qpsql "$psock" "$pport" <<'SQL'
CREATE TABLE hs (id int PRIMARY KEY, pad text);
INSERT INTO hs SELECT g, repeat('h',100) FROM generate_series(1,20000) g;
CREATE TABLE lk (id int);
INSERT INTO lk VALUES (1);
CHECKPOINT;
SQL

    # --- standby via pg_basebackup -R ----------------------------------------
    rm -rf "$s"
    if ! pg_basebackup -h 127.0.0.1 -p "$pport" -U postgres -D "$s" -R -X stream \
            >/dev/null 2>&1; then
        log "  pg_basebackup failed; standby not created"
        stop_cluster "$p"; collect tier4 standby_primary "$p"
        return
    fi
    apply_logging_conf "$s/postgresql.conf"
    local sport=$((pport + 50)) ssock="$root/sock_standby"
    mkdir -p "$ssock"
    {
        echo "port = $sport"
        echo "unix_socket_directories = '$ssock'"
        echo "listen_addresses = 'localhost'"
        echo "hot_standby = on"
        # The knobs that turn replay conflicts into immediate cancellations.
        echo "max_standby_streaming_delay = 0"
        echo "max_standby_archive_delay = 0"
        echo "hot_standby_feedback = off"
    } >> "$s/postgresql.conf"
    start_cluster "$s"
    sleep 2

    # --- provoke a snapshot conflict -----------------------------------------
    # Long reader on the standby holding an old snapshot; meanwhile the primary
    # updates+VACUUMs hs, removing rows the standby's snapshot still needs. With
    # max_standby_streaming_delay=0 the standby cancels the reader:
    # "canceling statement due to conflict with recovery".
    (
        qpsql "$ssock" "$sport" -c \
            "BEGIN ISOLATION LEVEL REPEATABLE READ;
             SELECT count(*) FROM hs;
             SELECT pg_sleep(10);
             SELECT count(*) FROM hs;
             COMMIT;"
    ) &
    local reader=$!
    sleep 2
    qpsql "$psock" "$pport" <<'SQL'
UPDATE hs SET pad = repeat('x',100) WHERE id <= 20000;
DELETE FROM hs WHERE id % 2 = 0;
VACUUM (VERBOSE) hs;
CHECKPOINT;
SQL
    sleep 3

    # A lock conflict too: hold a reader on lk at the standby while the primary
    # takes AccessExclusive (DROP), which the standby must replay -> the buffer/
    # lock conflict resolvers fire.
    (
        qpsql "$ssock" "$sport" -c \
            "BEGIN; SELECT * FROM lk; SELECT pg_sleep(6); COMMIT;"
    ) &
    local reader2=$!
    sleep 1
    qpsql "$psock" "$pport" -c "DROP TABLE lk;"
    qpsql "$psock" "$pport" -c "CHECKPOINT;"
    sleep 3

    wait "$reader" 2>/dev/null || true
    wait "$reader2" 2>/dev/null || true

    # --- promotion -----------------------------------------------------------
    # "received promote request" + end-of-recovery + a timeline bump on the
    # standby (xlogrecovery.c / timeline.c).
    pg_ctl -D "$s" promote >/dev/null 2>&1 || true
    sleep 3
    qpsql "$ssock" "$sport" -c "SELECT pg_is_in_recovery();"
    stop_cluster "$s"
    collect tier4 standby_conflict "$s"       # <-- the primary cap for this scenario

    stop_cluster "$p"
    collect tier4 standby_primary "$p"
}

run_scenario standby_conflict scenario_standby_conflict
