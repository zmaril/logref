#!/usr/bin/env bash
#
# LogRef reproducer — Tier 4 — PITR / archive recovery.
#
# Beyond the basic auto-recovery the crash_recovery scenario already covers, this
# drives the full point-in-time-recovery path: a primary archiving WAL to a
# scratch archive dir, a base backup, then several restored clusters replaying
# from the archive against different recovery targets — a reachable named target
# (which promotes onto a NEW TIMELINE), an unreachable named target, and a target
# time before the consistency point. Those hit LOG/FATAL call sites unreachable
# without archive recovery.
#
# Target C files:
#   src/backend/access/transam/xlogrecovery.c  ("starting point-in-time recovery
#       to ...", "recovery stopping ...", "recovery ended before configured
#       recovery target was reached", "requested recovery stop point is before
#       consistent recovery point", "restored ... reached consistency")
#   src/backend/access/transam/xlogarchive.c   ("restored log file ... from
#       archive", "could not restore file ... from archive")
#   src/backend/access/transam/timeline.c      ("selected new timeline ID: N",
#       new-timeline .history creation)
#   src/backend/access/transam/xlog.c          (checkpoint / backup start-stop)
#
# Standalone: source lib.sh, driver_env_setup, run, collect a tier4__pitr_restore
# cap into $CAPS. Mirrors env-run.sh (set -uo pipefail, no -e, so the deliberately
# FATAL restore boots don't abort the run).

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/../lib.sh"
scenario_driver_init                      # LOG_LEVEL=debug5 default, PGBIN/port setup

scenario_pitr_restore() {
    local root="$OUTDIR/pitr"
    local p="$root/primary"
    local ARCH="$root/archive"
    local BACKUP="$root/backup"
    mkdir -p "$ARCH"

    # --- primary: WAL archiving on -------------------------------------------
    init_cluster "$p"
    {
        echo "wal_level = replica"
        echo "archive_mode = on"
        # %p is relative to PGDATA (archive_command runs with cwd=PGDATA), %f the
        # segment name. The test-guard keeps a re-archive from erroring.
        echo "archive_command = 'test ! -f $ARCH/%f && cp %p $ARCH/%f'"
        echo "max_wal_senders = 10"
        echo "archive_timeout = 0"
    } >> "$p/postgresql.conf"
    echo "host replication postgres 127.0.0.1/32 trust" >> "$p/pg_hba.conf"
    echo "local replication postgres trust" >> "$p/pg_hba.conf"
    start_cluster "$p"
    local psock=$PGSOCK pport=$PGPORT

    # Some data, then take the base backup while the server runs.
    qpsql "$psock" "$pport" <<'SQL'
CREATE TABLE pit (id int PRIMARY KEY, pad text);
INSERT INTO pit SELECT g, repeat('a',100) FROM generate_series(1,2000) g;
SELECT pg_switch_wal();
CHECKPOINT;
SQL

    rm -rf "$BACKUP"
    if ! pg_basebackup -h 127.0.0.1 -p "$pport" -U postgres -D "$BACKUP" \
            -X stream >/dev/null 2>&1; then
        log "  pg_basebackup failed; trying pg_backup_start/stop filesystem copy"
        # Fallback: exclusive-free filesystem backup (PG15 non-exclusive API).
        qpsql "$psock" "$pport" -c "SELECT pg_backup_start('pitr');"
        rm -rf "$BACKUP"; cp -a "$p" "$BACKUP" 2>/dev/null || true
        qpsql "$psock" "$pport" -c "SELECT * FROM pg_backup_stop();"
        rm -f "$BACKUP/postmaster.pid"
    fi

    # --- forward WAL past the backup, plant a named restore point ------------
    # rp1 is created AFTER the backup so recovery must replay forward (and reach
    # consistency) before it can stop there.
    qpsql "$psock" "$pport" <<'SQL'
INSERT INTO pit SELECT g, repeat('b',100) FROM generate_series(2001,4000) g;
SELECT pg_switch_wal();
SELECT pg_create_restore_point('rp1');
INSERT INTO pit SELECT g, repeat('c',100) FROM generate_series(4001,6000) g;
SELECT pg_switch_wal();
CHECKPOINT;
SQL
    sleep 1
    stop_cluster "$p"
    collect tier4 pitr_primary "$p"

    if [ ! -d "$BACKUP" ] || [ ! -f "$BACKUP/PG_VERSION" ]; then
        log "  no usable base backup; skipping restores"
        return
    fi

    # write_recovery <restoredir> <socketdir> <extra recovery GUC lines...>
    # Copy the base backup, disable its own archiving, wire a restore_command +
    # a private port/socket, drop the recovery target GUCs in, arm recovery.
    local rport
    write_recovery() {
        local rdir="$1" rsock="$2"; shift 2
        rm -rf "$rdir"; cp -a "$BACKUP" "$rdir"
        rm -f "$rdir/postmaster.pid"
        mkdir -p "$rsock"
        rport=$((PGPORT_NEXT)); PGPORT_NEXT=$((rport + 1))
        {
            echo ""
            echo "# --- PITR restore overrides ---"
            echo "archive_mode = off"
            echo "restore_command = 'cp $ARCH/%f %p'"
            echo "port = $rport"
            echo "unix_socket_directories = '$rsock'"
            echo "listen_addresses = 'localhost'"
            echo "hot_standby = on"
            local ln
            for ln in "$@"; do echo "$ln"; done
        } >> "$rdir/postgresql.conf"
        # PG12+: recovery.signal arms archive recovery from postgresql.conf.
        : > "$rdir/recovery.signal"
    }

    # (A) reachable named target -> reaches consistency, stops at rp1, and with
    #     recovery_target_action = promote forks a NEW TIMELINE (timeline.c).
    local ra="$root/restore_named" rasock="$root/sock_named"
    write_recovery "$ra" "$rasock" \
        "recovery_target_name = 'rp1'" \
        "recovery_target_action = 'promote'"
    start_cluster "$ra"          # may take a moment to promote
    sleep 2
    # After promotion the restored cluster is a live primary again; read it back
    # over the private socket we assigned in write_recovery.
    qpsql "$rasock" "$rport" -c "SELECT count(*) FROM pit;"
    stop_cluster "$ra"
    collect tier4 pitr_restore "$ra"       # <-- the primary tier4__pitr_restore cap
    # timeline history files land under pg_wal (00000002.history); note whether
    # a new timeline was forked.
    ls "$ra/pg_wal"/*.history >/dev/null 2>&1 \
        && log "  timeline history present: $(ls "$ra"/pg_wal/*.history 2>/dev/null | xargs -n1 basename | tr '\n' ' ')" \
        || log "  no .history file (timeline switch may not have occurred)"

    # (B) UNREACHABLE named target -> recovery replays to end of WAL without ever
    #     finding it, then FATALs "recovery ended before configured recovery
    #     target was reached", and "could not restore file" as it runs off the
    #     archive (xlogarchive.c). This boot is EXPECTED to exit non-zero.
    local rb="$root/restore_badname" rbsock="$root/sock_badname"
    write_recovery "$rb" "$rbsock" \
        "recovery_target_name = 'no_such_point'" \
        "recovery_target_action = 'shutdown'"
    start_cluster "$rb"          # expected to fail to reach "ready"
    sleep 2
    stop_cluster "$rb"
    collect tier4 pitr_unreached "$rb"

    # (C) target TIME before the consistency point -> FATAL "requested recovery
    #     stop point is before consistent recovery point". Also EXPECTED to fail.
    local rc="$root/restore_pasttime" rcsock="$root/sock_pasttime"
    write_recovery "$rc" "$rcsock" \
        "recovery_target_time = '2000-01-01 00:00:00+00'" \
        "recovery_target_action = 'shutdown'"
    start_cluster "$rc"
    sleep 2
    stop_cluster "$rc"
    collect tier4 pitr_beforeconsistent "$rc"
}

run_scenario pitr_restore scenario_pitr_restore
