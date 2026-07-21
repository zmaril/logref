#!/usr/bin/env bash
#
# LogRef reproducer driver — Tier 3-4 env-variant scenarios.
#
# Where run.sh drives a single stock cluster through crafted SQL (Tiers 1-2),
# this driver stands up deliberately hostile *environments* — broken config,
# rejecting auth, corrupted data files, a primary/standby pair, exhausted
# resources, an un-clean shutdown — and captures the LOG/FATAL/PANIC call sites
# those provoke, which SQL against a healthy cluster can never reach.
#
# It is the direct-build measurement path for the env images under env/ (the
# Docker daemon is often unavailable in CI, so the images are the committed
# deliverable and this script is how we MEASURE). Each scenario runs in its own
# scratch cluster(s); the jsonlog of each is copied into $OUTDIR/caps tagged by
# tier and scenario, and env-coverage.py joins the union against the catalog and
# reports the delta over the Tier 1-2 baseline.
#
# Env:
#   PGBIN     dir with initdb/postgres/psql/pg_basebackup/pg_amcheck (or on PATH)
#   PGLIB     dir with libpq.so (exported as LD_LIBRARY_PATH for a from-source
#             build whose client tools must not pick up a system libpq)
#   CATALOG   path to the catalog JSONL (required for the report step)
#   BASELINE  optional Tier 1-2 capture jsonlog, for the delta in the report
#   OUTDIR    scratch root for clusters + captures (default: mktemp)
#   LOG_LEVEL log_min_messages (default debug1)
#   ONLY      space-separated subset of scenarios to run (default: all)
#
# Postgres refuses to run as root; run this as an unprivileged user. The
# disk-full scenario needs a tmpfs mount (root) and is skipped with a note when
# that is not available.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/lib.sh"
driver_env_setup                 # PGBIN/PGLIB path, initdb check, OUTDIR/CAPS
export PGPORT_NEXT=55990

# collect <tier> <scenario> <datadir> — copy a cluster's jsonlog into caps/,
# tagged, so env-coverage.py can attribute sites to the tier that fired them.
collect() {
    local tier="$1" scen="$2" datadir="$3"
    local src; src="$(jsonlog_of "$datadir")"
    if [ -n "$src" ] && [ -f "$src" ]; then
        cp "$src" "$CAPS/${tier}__${scen}.json"
        log "  captured $(wc -l <"$src") lines -> ${tier}__${scen}.json"
    else
        log "  no jsonlog for $scen (cluster may not have booted)"
    fi
}

# ---------------------------------------------------------------------------
# Tier 3 — configuration & GUC.
# A booted cluster reloaded onto broken config, plus session/system SET of
# invalid GUC values. check_hook rejections and the config-file reload path
# print through guc.c / the per-GUC validators — LOG and ERROR sites unreachable
# from a well-formed cluster.
# ---------------------------------------------------------------------------
scenario_bad_config() {
    local d="$OUTDIR/badcfg/pgdata"
    init_cluster "$d"
    start_cluster "$d"
    local sock=$PGSOCK port=$PGPORT

    # Session-level SET of invalid / out-of-range / wrong-context GUCs.
    qpsql "$sock" "$port" <<'SQL'
SET work_mem = '1kB';
SET work_mem = 'notasize';
SET datestyle = 'bogus';
SET timezone = 'Mars/Phobos';
SET client_encoding = 'NOSUCHENCODING';
SET client_min_messages = 'nonsense';
SET default_transaction_isolation = 'bananas';
SET statement_timeout = 'ages';
SET bytea_output = 'sideways';
SET IntervalStyle = 'roman_numerals';
SET random_page_cost = -1;
SET wal_level = 'minimal';
SET max_connections = 10;
SET shared_buffers = '999GB';
SET does_not_exist = 'x';
SET search_path = '"';
ALTER SYSTEM SET max_wal_size = 'tiny';
ALTER SYSTEM SET archive_mode = 'perhaps';
ALTER SYSTEM SET nonexistent_guc = 1;
ALTER DATABASE postgres SET work_mem = 'nope';
ALTER SYSTEM RESET ALL;
SQL

    # Reload the postmaster onto a config file carrying invalid values: the
    # reload path logs per-parameter and reports it cannot apply them.
    cat >> "$d/postgresql.conf" <<'CONF'
# --- deliberately broken values for the reload path ---
work_mem = '3kB'
max_connections = 4
shared_buffers = '128MB'
log_min_messages = 'chatty'
datestyle = 'nonsense, values'
CONF
    pg_ctl -D "$d" reload >/dev/null 2>&1 || true
    sleep 1
    stop_cluster "$d"
    collect tier3 bad_config "$d"
}

# ---------------------------------------------------------------------------
# Tier 3 — authentication, pg_hba, and SSL.
# pg_hba.conf variants (reject / scram mismatch / no entry) plus a required-SSL
# endpoint hit without SSL. Failed TCP logins print FATAL through auth.c /
# hba.c / auth-scram.c / be-secure*.c.
# ---------------------------------------------------------------------------
scenario_auth_ssl() {
    local d="$OUTDIR/auth/pgdata"
    init_cluster "$d"
    echo "password_encryption = 'scram-sha-256'" >> "$d/postgresql.conf"

    # Optional TLS: a self-signed server cert enables hostssl edges.
    local have_ssl=0
    if command -v openssl >/dev/null; then
        openssl req -new -x509 -days 1 -nodes -text \
            -subj "/CN=localhost" \
            -keyout "$d/server.key" -out "$d/server.crt" >/dev/null 2>&1 \
            && chmod 600 "$d/server.key" && have_ssl=1
    fi
    if [ "$have_ssl" = 1 ]; then
        {
            echo "ssl = on"
            echo "ssl_cert_file = 'server.crt'"
            echo "ssl_key_file = 'server.key'"
        } >> "$d/postgresql.conf"
    fi

    start_cluster "$d"
    local sock=$PGSOCK port=$PGPORT

    qpsql "$sock" "$port" <<'SQL'
CREATE ROLE alice LOGIN PASSWORD 'correct-horse';
CREATE ROLE rejected LOGIN PASSWORD 'x';
CREATE ROLE nomatch LOGIN PASSWORD 'x';
SQL

    # Hostile pg_hba: reject one role, scram another, and leave a gap.
    cat > "$d/pg_hba.conf" <<HBA
local   all   postgres                  trust
host    all   rejected   127.0.0.1/32   reject
host    all   alice      127.0.0.1/32   scram-sha-256
host    all   nomatch    10.255.255.1/32 scram-sha-256
$( [ "$have_ssl" = 1 ] && echo "hostssl all sslonly 127.0.0.1/32 scram-sha-256" )
host    all   sslonly    127.0.0.1/32   reject
HBA
    pg_ctl -D "$d" reload >/dev/null 2>&1 || true
    sleep 1

    # Drive failing TCP logins (each is one auth FATAL call site).
    local h=127.0.0.1
    PGPASSWORD=wrong    psql "host=$h port=$port user=alice dbname=postgres"    -c 'SELECT 1' >/dev/null 2>&1 || true
    PGPASSWORD=x        psql "host=$h port=$port user=rejected dbname=postgres" -c 'SELECT 1' >/dev/null 2>&1 || true
    PGPASSWORD=x        psql "host=$h port=$port user=nomatch dbname=postgres"  -c 'SELECT 1' >/dev/null 2>&1 || true
    PGPASSWORD=x        psql "host=$h port=$port user=ghost dbname=postgres"    -c 'SELECT 1' >/dev/null 2>&1 || true
    PGPASSWORD=x        psql "host=$h port=$port user=alice dbname=nosuchdb"    -c 'SELECT 1' >/dev/null 2>&1 || true
    if [ "$have_ssl" = 1 ]; then
        PGPASSWORD=x psql "host=$h port=$port user=sslonly dbname=postgres sslmode=disable" -c 'SELECT 1' >/dev/null 2>&1 || true
        PGPASSWORD=x psql "host=$h port=$port user=sslonly dbname=postgres sslmode=require" -c 'SELECT 1' >/dev/null 2>&1 || true
    fi
    sleep 1
    stop_cluster "$d"
    collect tier3 auth_ssl "$d"
}

# ---------------------------------------------------------------------------
# Tier 4 — data corruption.
# A checksummed throwaway cluster whose heap page is scribbled while stopped;
# on the next read the page-verification path (bufpage.c / md.c) refuses it, and
# pg_amcheck walks the heap/btree reporting corruption (verify_heapam.c,
# verify_nbtree.c).
# ---------------------------------------------------------------------------
scenario_corruption() {
    local d="$OUTDIR/corrupt/pgdata"
    init_cluster "$d" -k          # data checksums on
    start_cluster "$d"
    local sock=$PGSOCK port=$PGPORT
    qpsql "$sock" "$port" <<'SQL'
CREATE TABLE victim (id int PRIMARY KEY, pad text);
INSERT INTO victim SELECT g, repeat('x', 200) FROM generate_series(1, 500) g;
CHECKPOINT;
SQL
    local relpath
    relpath="$(psql -h "$sock" -p "$port" -U postgres -d postgres -Atqc \
        "SELECT pg_relation_filepath('victim')" 2>/dev/null)"
    stop_cluster "$d"

    if [ -n "$relpath" ] && [ -f "$d/$relpath" ]; then
        # Scribble bytes across the first data page (offset 512 skips the page
        # header's own fields but lands inside the checksum-covered body).
        dd if=/dev/urandom of="$d/$relpath" bs=1 seek=512 count=64 conv=notrunc >/dev/null 2>&1
        # Truncate the second segment / FSM to provoke short-read paths too.
        : > "$d/${relpath}_fsm" 2>/dev/null || true
    fi

    start_cluster "$d"
    sock=$PGSOCK; port=$PGPORT
    qpsql "$sock" "$port" -c "SET zero_damaged_pages = off; SELECT count(*) FROM victim;"
    qpsql "$sock" "$port" -c "SELECT * FROM victim WHERE id = 1;"
    # amcheck: heap + btree verification over the (now corrupt) relation.
    qpsql "$sock" "$port" -c "CREATE EXTENSION IF NOT EXISTS amcheck;"
    pg_amcheck -h "$sock" -p "$port" -U postgres -d postgres --heapallindexed \
        --no-dependent-indexes >/dev/null 2>&1 || true
    sleep 1
    stop_cluster "$d"
    collect tier4 corruption "$d"
}

# ---------------------------------------------------------------------------
# Tier 4 — streaming replication, slots, and promotion.
# A primary, a pg_basebackup standby streaming from it via a slot, then a
# promotion. Exercises walsender/walreceiver, the base-backup server code, the
# recovery/startup path and slot management — LOG sites a lone cluster never
# emits.
# ---------------------------------------------------------------------------
scenario_replication() {
    local p="$OUTDIR/repl/primary" s="$OUTDIR/repl/standby"
    init_cluster "$p"
    {
        echo "wal_level = replica"
        echo "max_wal_senders = 10"
        echo "max_replication_slots = 10"
        echo "hot_standby = on"
        echo "hot_standby_feedback = on"
    } >> "$p/postgresql.conf"
    echo "host replication postgres 127.0.0.1/32 trust" >> "$p/pg_hba.conf"
    echo "local replication postgres trust" >> "$p/pg_hba.conf"
    start_cluster "$p"
    local psock=$PGSOCK pport=$PGPORT
    qpsql "$psock" "$pport" -c "SELECT pg_create_physical_replication_slot('standby_slot');"
    qpsql "$psock" "$pport" <<'SQL'
CREATE TABLE t (id int);
INSERT INTO t SELECT generate_series(1, 1000);
SELECT pg_switch_wal();
CHECKPOINT;
SQL

    # Base-backup a standby off the primary's TCP port, then stream from a slot.
    rm -rf "$s"
    if pg_basebackup -h 127.0.0.1 -p "$pport" -U postgres -D "$s" -R -X stream \
            -S standby_slot >/dev/null 2>&1; then
        apply_logging_conf "$s/postgresql.conf"
        local sport=$((pport + 50))
        {
            echo "port = $sport"
            echo "unix_socket_directories = '$OUTDIR/repl/sstandby'"
            echo "listen_addresses = 'localhost'"
            echo "hot_standby = on"
        } >> "$s/postgresql.conf"
        mkdir -p "$OUTDIR/repl/sstandby"
        start_cluster "$s"
        sleep 2
        # Generate WAL on the primary; the standby replays it (recovery LOGs).
        qpsql "$psock" "$pport" -c "INSERT INTO t SELECT generate_series(1,5000); CHECKPOINT;"
        sleep 2
        # Promote the standby: end-of-recovery / promotion LOGs on the standby.
        pg_ctl -D "$s" promote >/dev/null 2>&1 || true
        sleep 2
        stop_cluster "$s"
        collect tier4 replication_standby "$s"
    else
        log "  pg_basebackup failed; standby not created"
    fi
    stop_cluster "$p"
    collect tier4 replication_primary "$p"
}

# ---------------------------------------------------------------------------
# Tier 4 — logical replication (publication/subscription).
# A publisher with wal_level=logical and a subscriber that CREATE SUBSCRIPTIONs
# to it: logical decoding, the apply worker, table sync, the snapshot builder
# and replication origin all come alive — decode.c / snapbuild.c / reorderbuffer.c
# / worker.c / tablesync.c / origin.c / logical.c LOG+DEBUG sites.
# ---------------------------------------------------------------------------
scenario_logical() {
    local pub="$OUTDIR/logi/pub" sub="$OUTDIR/logi/sub"
    init_cluster "$pub"
    {
        echo "wal_level = logical"
        echo "max_wal_senders = 10"
        echo "max_replication_slots = 10"
        echo "log_replication_commands = on"
    } >> "$pub/postgresql.conf"
    echo "host all postgres 127.0.0.1/32 trust" >> "$pub/pg_hba.conf"
    echo "host replication postgres 127.0.0.1/32 trust" >> "$pub/pg_hba.conf"
    start_cluster "$pub"
    local pubsock=$PGSOCK pubport=$PGPORT

    init_cluster "$sub"
    {
        echo "wal_level = logical"
        echo "max_logical_replication_workers = 8"
        echo "max_worker_processes = 12"
        echo "max_replication_slots = 10"
    } >> "$sub/postgresql.conf"
    start_cluster "$sub"
    local subsock=$PGSOCK subport=$PGPORT

    qpsql "$pubsock" "$pubport" <<'SQL'
CREATE TABLE t (id int PRIMARY KEY, v text);
INSERT INTO t SELECT g, 'row'||g FROM generate_series(1,500) g;
CREATE PUBLICATION p FOR ALL TABLES;
SQL
    qpsql "$subsock" "$subport" -c "CREATE TABLE t (id int PRIMARY KEY, v text);"
    qpsql "$subsock" "$subport" -c \
        "CREATE SUBSCRIPTION s CONNECTION 'host=127.0.0.1 port=$pubport user=postgres dbname=postgres' PUBLICATION p;"
    sleep 3
    # More traffic to decode + apply, then drop (slot teardown logs).
    qpsql "$pubsock" "$pubport" -c "INSERT INTO t SELECT g, 'more'||g FROM generate_series(501,3000) g; UPDATE t SET v=v||'!' WHERE id<50; DELETE FROM t WHERE id>2900;"
    sleep 3
    qpsql "$subsock" "$subport" -c "DROP SUBSCRIPTION s;"
    sleep 1
    stop_cluster "$sub"; collect tier4 logical_subscriber "$sub"
    stop_cluster "$pub"; collect tier4 logical_publisher "$pub"
}

# ---------------------------------------------------------------------------
# Tier 3 — malformed pg_hba.conf / pg_ident.conf reload.
# Reloading the postmaster onto authentication files with unknown methods,
# bad CIDRs and broken ident maps makes the tokenizer/validator log a parse
# error per offending line — the hba.c reporting path, unreachable while the
# files are well-formed.
# ---------------------------------------------------------------------------
scenario_bad_hba() {
    local d="$OUTDIR/badhba/pgdata"
    init_cluster "$d"
    start_cluster "$d"
    cat > "$d/pg_hba.conf" <<'HBA'
local   all   postgres                  trust
# unknown auth method
host    all   all   127.0.0.1/32        no_such_method
# bad CIDR mask
host    all   all   127.0.0.1/999       scram-sha-256
# missing field
host    all   all
# unknown option
host    all   all   127.0.0.1/32        scram-sha-256   badoption=1
# reference an ident map that will be malformed
host    all   all   127.0.0.1/32        ident map=broken
HBA
    cat > "$d/pg_ident.conf" <<'IDENT'
broken
broken  /(  pg
IDENT
    pg_ctl -D "$d" reload >/dev/null 2>&1 || true
    sleep 1
    # A connection attempt now forces the backend to re-read the broken files.
    PGPASSWORD=x psql "host=127.0.0.1 port=$PGPORT user=postgres dbname=postgres" \
        -c 'SELECT 1' >/dev/null 2>&1 || true
    sleep 1
    stop_cluster "$d"
    collect tier3 bad_hba "$d"
}

# ---------------------------------------------------------------------------
# Tier 4 — resource exhaustion.
# Statement/lock/idle timeouts, connection-limit refusals, and (if a tmpfs can
# be mounted) a disk-full write. These fire the cancellation and admission-
# control sites in postgres.c / proc.c / postmaster.c, and the out-of-space
# write paths in md.c / xlog.c / fd.c.
# ---------------------------------------------------------------------------
scenario_resource() {
    local d="$OUTDIR/res/pgdata"
    init_cluster "$d"
    echo "max_connections = 3" >> "$d/postgresql.conf"
    echo "superuser_reserved_connections = 1" >> "$d/postgresql.conf"
    start_cluster "$d"
    local sock=$PGSOCK port=$PGPORT

    # Timeouts.
    qpsql "$sock" "$port" -c "SET statement_timeout = '50ms'; SELECT pg_sleep(2);"
    qpsql "$sock" "$port" -c "SET idle_in_transaction_session_timeout = '50ms'; BEGIN; SELECT pg_sleep(1);"
    # lock_timeout: hold an AccessExclusive lock in the background, then contend.
    ( qpsql "$sock" "$port" -c "BEGIN; LOCK TABLE pg_class IN ACCESS EXCLUSIVE MODE; SELECT pg_sleep(3); COMMIT;" ) &
    local holder=$!
    sleep 1
    qpsql "$sock" "$port" -c "SET lock_timeout = '100ms'; SELECT * FROM pg_class LIMIT 1 FOR UPDATE;"
    qpsql "$sock" "$port" -c "SET deadlock_timeout = '50ms'; SET lock_timeout='200ms'; LOCK TABLE pg_class;"
    wait $holder 2>/dev/null || true

    # Connection storm: open more than max_connections at once.
    local pids=()
    for _ in $(seq 1 8); do
        ( psql -h "$sock" -p "$port" -U postgres -d postgres -c "SELECT pg_sleep(2)" >/dev/null 2>&1 ) &
        pids+=($!)
    done
    for pid in "${pids[@]}"; do wait "$pid" 2>/dev/null || true; done
    sleep 1
    stop_cluster "$d"
    collect tier4 resource_timeouts "$d"

    # Disk-full: only if we can mount a small tmpfs (needs root).
    scenario_disk_full
}

scenario_disk_full() {
    # A small full-able filesystem. Prefer one pre-mounted by root and handed in
    # via DISKFULL_DIR (the direct-measure path, since mount needs root); else
    # try to mount a tmpfs ourselves (works when the driver itself is root).
    local mnt
    if [ -n "${DISKFULL_DIR:-}" ] && [ -w "${DISKFULL_DIR:-}" ]; then
        mnt="$DISKFULL_DIR"
    else
        mnt="$OUTDIR/tinyfs"
        mkdir -p "$mnt"
        if ! mount -t tmpfs -o size=48m tmpfs "$mnt" 2>/dev/null; then
            log "  disk-full: no writable tmpfs (need root / DISKFULL_DIR); skipped"
            return
        fi
    fi
    local d="$mnt/pgdata"
    if init_cluster "$d" 2>/dev/null && start_cluster "$d"; then
        local sock=$PGSOCK port=$PGPORT
        # Write until the filesystem fills — the out-of-space error fires on the
        # write/extend path.
        qpsql "$sock" "$port" -c "CREATE TABLE fill (pad text);"
        qpsql "$sock" "$port" -c "INSERT INTO fill SELECT repeat('x',1000) FROM generate_series(1,10000000);"
        qpsql "$sock" "$port" -c "SELECT 1;"
        sleep 1
        stop_cluster "$d" immediate
        collect tier4 disk_full "$d"
    else
        log "  disk-full: initdb/boot on tmpfs failed (too small); skipped"
    fi
    [ -n "${DISKFULL_DIR:-}" ] || umount "$mnt" 2>/dev/null || true
}

# ---------------------------------------------------------------------------
# Tier 4 — crash recovery.
# An un-clean shutdown (SIGQUIT immediate, then a real SIGKILL of the postmaster)
# leaves the cluster dirty; the next start runs automatic recovery, printing the
# "was interrupted / not properly shut down / redo starts at" LOG sites in
# xlog.c / xlogrecovery.c / startup.c.
# ---------------------------------------------------------------------------
scenario_crash_recovery() {
    local d="$OUTDIR/crash/pgdata"
    init_cluster "$d"
    start_cluster "$d"
    local sock=$PGSOCK port=$PGPORT
    qpsql "$sock" "$port" <<'SQL'
CREATE TABLE c (id int, pad text);
INSERT INTO c SELECT g, repeat('y',100) FROM generate_series(1,50000) g;
SQL
    # Dirty the buffers, then kill the postmaster hard mid-write.
    ( qpsql "$sock" "$port" -c "INSERT INTO c SELECT g, repeat('z',100) FROM generate_series(1,200000) g;" ) &
    sleep 1
    local pmpid
    pmpid="$(head -1 "$d/postmaster.pid" 2>/dev/null)"
    if [ -n "$pmpid" ]; then
        kill -9 "$pmpid" 2>/dev/null || true
        # Kill any surviving backends so the port frees up.
        pkill -9 -f "postgres.*$d" 2>/dev/null || true
    fi
    sleep 2
    # Restart: crash recovery runs.
    start_cluster "$d"
    sleep 1
    qpsql "$PGSOCK" "$PGPORT" -c "SELECT count(*) FROM c;"
    stop_cluster "$d"
    collect tier4 crash_recovery "$d"
}

# ---------------------------------------------------------------------------

ALL="bad_config bad_hba auth_ssl corruption replication logical resource crash_recovery"
RUN="${ONLY:-$ALL}"
for name in $RUN; do
    log "=== scenario: $name ==="
    "scenario_$name" || log "  scenario $name exited non-zero (continuing)"
done

# Report step (optional — only if a catalog is provided).
if [ -n "${CATALOG:-}" ]; then
    baseline_arg=()
    [ -n "${BASELINE:-}" ] && baseline_arg=(--baseline "$BASELINE")
    python3 "$HERE/env-coverage.py" \
        --catalog "$CATALOG" \
        --caps "$CAPS" \
        "${baseline_arg[@]}" \
        --out "$HERE/coverage-report.md" \
        --json-out "$HERE/reproduced-sites.json" \
        --commit "$(cat "${COMMIT_FILE:-/dev/null}" 2>/dev/null || echo unknown)"
    log "report + reproduced-sites.json written"
else
    log "no CATALOG set; captures left in $CAPS"
fi
log "done. scratch: $OUTDIR"
