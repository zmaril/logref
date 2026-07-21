# shellcheck shell=bash
#
# Shared cluster-lifecycle helpers for the LogRef reproducer harness.
#
# Both the Tier 1-2 driver (run.sh) and the Tier 3-4 env-variant driver
# (env-run.sh) need the same handful of operations: stamp a data dir with the
# provenance logging config, boot a cluster in a scratch dir, drive psql, and
# find the captured jsonlog. Factoring them here keeps the scenario code free of
# duplicated boilerplate (each scenario is then just "what's different about this
# cluster").
#
# The functions are deliberately small and side-effecting on a per-cluster
# directory, so an env-variant scenario can spin up several clusters (e.g. a
# primary and a standby) without stepping on each other.

# Locate the logging config next to this library regardless of caller CWD.
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGGING_CONF="${LOGGING_CONF:-$_LIB_DIR/base/logging.conf}"

log() { printf '[env] %s\n' "$*" >&2; }

# apply_logging_conf <postgresql.conf> [log_min_messages]
# Append the shared provenance config and pin the message level. This is what
# makes every captured line carry file_name/file_line_num for the catalog join.
apply_logging_conf() {
    local conf="$1" level="${2:-${LOG_LEVEL:-debug1}}"
    cat "$LOGGING_CONF" >> "$conf"
    {
        echo ""
        echo "# --- driver override ---"
        echo "log_min_messages = $level"
        echo "log_min_error_statement = $level"
    } >> "$conf"
}

# init_cluster <datadir> [initdb-extra-args...]
# initdb a fresh cluster, wire it for jsonlog, give it a private socket dir and
# port. Extra args are passed through to initdb (e.g. -k for data checksums).
# Sets globals PGDATA_DIR, PGPORT, PGSOCK for the just-initialised cluster.
init_cluster() {
    local datadir="$1"; shift || true
    mkdir -p "$datadir"
    initdb -D "$datadir" -U postgres --locale=C "$@" >/dev/null
    apply_logging_conf "$datadir/postgresql.conf"
    PGPORT="${PGPORT_NEXT:-55990}"
    PGPORT_NEXT=$((PGPORT + 1))
    PGSOCK="${PGSOCK:-$(mktemp -d /tmp/lrs.XXXXXX)}"
    mkdir -p "$PGSOCK"
    {
        echo "port = $PGPORT"
        echo "unix_socket_directories = '$PGSOCK'"
        echo "listen_addresses = 'localhost'"
    } >> "$datadir/postgresql.conf"
    PGDATA_DIR="$datadir"
}

# start_cluster <datadir> [serverlog]  — boot and wait.
start_cluster() {
    local datadir="$1" serverlog="${2:-$1/server.log}"
    pg_ctl -D "$datadir" -l "$serverlog" -w start >/dev/null 2>&1
}

# stop_cluster <datadir> [mode]  — mode fast|immediate|smart (default fast).
stop_cluster() {
    local datadir="$1" mode="${2:-fast}"
    pg_ctl -D "$datadir" -m "$mode" stop >/dev/null 2>&1 || true
}

# psql on a cluster's socket. First arg is the socket dir, second the port, rest
# are psql args. Errors are the point of most scenarios, so never fail the run.
qpsql() {
    local sock="$1" port="$2"; shift 2
    psql -h "$sock" -p "$port" -U postgres -d postgres -v ON_ERROR_STOP=0 -q "$@" \
        >/dev/null 2>&1 || true
}

# jsonlog_of <datadir>  — echo the path to the captured jsonlog for a cluster.
jsonlog_of() {
    find "$1/log" -name '*.json' -print 2>/dev/null | head -1
}

# capture_scenario <sock> <port> <logfile> <capdir> <sqlfile> [tier]
# Isolate one scenario's jsonlog and copy it to <capdir>/<tier>__<name>.json.
# Truncate the live log, run just this file, run a trailing statement to flush
# the last record, then snapshot. This is the per-scenario capture step every
# Tier 2+ driver shares; keeping it here means a new driver is just "which files"
# rather than a re-copy of the isolate/run/flush/snapshot dance.
capture_scenario() {
    local sock="$1" port="$2" logfile="$3" capdir="$4" sqlfile="$5" tier="${6:-tier2}"
    local name; name="$(basename "$sqlfile" .sql)"
    : > "$logfile"
    qpsql "$sock" "$port" -f "$sqlfile"
    qpsql "$sock" "$port" -c "SELECT 1"
    cp "$logfile" "$capdir/${tier}__${name}.json"
    log "  captured $(wc -l <"$logfile") lines -> ${tier}__${name}.json"
}

# driver_env_setup — shared bootstrap for the per-scenario capture drivers
# (env-run.sh, sql-caps.sh): put PGBIN/PGLIB on the tool path, require initdb,
# and populate the scratch-root globals every driver writes captures into.
# Sets globals OUTDIR, LOG_LEVEL, CAPS.
driver_env_setup() {
    [ -n "${PGBIN:-}" ] && PATH="$PGBIN:$PATH"
    [ -n "${PGLIB:-}" ] && export LD_LIBRARY_PATH="$PGLIB:${LD_LIBRARY_PATH:-}"
    command -v initdb >/dev/null || { log "initdb not on PATH; set PGBIN"; exit 3; }
    OUTDIR="${OUTDIR:-$(mktemp -d)}"
    LOG_LEVEL="${LOG_LEVEL:-debug1}"
    CAPS="$OUTDIR/caps"
    mkdir -p "$CAPS"
}

# collect <tier> <scenario> <datadir> — copy a cluster's jsonlog into caps/,
# tagged "<tier>__<scenario>.json", so the coverage tooling can attribute the
# sites it fired to the tier and scenario that provoked them. A no-op with a note
# when the cluster produced no jsonlog (e.g. it never booted). Every capture
# driver needs exactly this, so it lives here rather than being copied per driver.
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

# scenario_driver_init [default_log_level] — shared top matter for the standalone
# Tier 4 scenario scripts (scenarios/54-57): default log_min_messages (debug5 for
# a maximum-coverage pass unless the caller already exported LOG_LEVEL), run the
# common driver bootstrap, and seed the port allocator. Collapses each scenario's
# preamble to a single call.
scenario_driver_init() {
    export LOG_LEVEL="${LOG_LEVEL:-${1:-debug5}}"
    driver_env_setup
    export PGPORT_NEXT="${PGPORT_NEXT:-55990}"
}

# run_scenario <name> <fn> — invoke a scenario function under the "continue on
# non-zero" discipline the Tier 4 scripts share (deliberately FATAL boots return
# non-zero and must not abort the run), bracketed by the standard start/done
# banner. Factored here so no two scenario scripts repeat the footer.
run_scenario() {
    local name="$1" fn="$2"
    log "=== scenario: $name ==="
    "$fn" || log "  scenario $name exited non-zero (continuing)"
    log "done. scratch: $OUTDIR  caps: $CAPS"
}

# ===========================================================================
# Replication helpers (Tier 4, scenarios 58-61).
#
# Physical/logical replication is inherently multi-cluster, so its scenarios are
# shell, not SQL. Everything a scenario needs beyond its own workload lives here,
# so the four scenario files stay free of shared setup boilerplate (the thing
# straitjacket's cross-file [duplication] rule fails on). They all build on the
# single-cluster primitives above (init_cluster/start_cluster/qpsql).
#
# The wait_* helpers connect over TCP (127.0.0.1) rather than the socket, since
# repl_primary_up opens a `host all postgres 127.0.0.1/32 trust` line and a
# base-backed standby inherits it — one address works for a primary and its
# standby alike. Every wait is bounded by a timeout so nothing blocks forever.
# ===========================================================================

# sock_of <datadir> — the short socket directory init_cluster now assigns every
# cluster. init_cluster defaults PGSOCK to a single mktemp dir under /tmp (kept
# well under the sockaddr_un ~100-char limit and reused across clusters), so each
# cluster is addressed by its own port within this one shared dir. The datadir
# argument is retained for call-site compatibility.
sock_of() { printf '%s' "${PGSOCK}"; }

# qval <port> <sql> — strict single-value query over TCP, for when a helper
# needs the answer (not just to tolerate an error). Echoes the scalar, or
# nothing on failure; never blocks past a short connect timeout.
qval() {
    psql "host=127.0.0.1 port=$1 user=postgres dbname=postgres connect_timeout=3" \
        -Atqc "$2" 2>/dev/null
}

# repl_conf <datadir> <key=value>...  — set replication GUCs idempotently:
# each key's prior line (if any) is dropped before the new value is appended, so
# re-running a scenario or overriding an inherited value never duplicates a key.
repl_conf() {
    local datadir="$1"; shift
    local conf="$datadir/postgresql.conf" kv key
    for kv in "$@"; do
        key="${kv%%=*}"; key="${key// /}"
        sed -i "/^[[:space:]]*${key}[[:space:]]*=/d" "$conf" 2>/dev/null || true
        printf '%s\n' "$kv" >> "$conf"
    done
}

# repl_basebackup_standby <primary_datadir> <primary_port> <standby_datadir> [pg_basebackup args...]
# pg_basebackup -R -X stream off the primary's socket, then hand the fresh copy
# its own port/socket (it inherited the primary's) using init_cluster's port
# allocator. Does NOT start it. Sets PGPORT/PGSOCK/PGDATA_DIR to the standby.
repl_basebackup_standby() {
    local pdata="$1" pport="$2" sdata="$3"; shift 3
    local psock; psock="$(sock_of "$pdata")"
    rm -rf "$sdata"
    "${PGBIN:+$PGBIN/}pg_basebackup" -h "$psock" -p "$pport" -U postgres \
        -D "$sdata" -R -X stream "$@" >/dev/null 2>&1 || return 1
    local sport="${PGPORT_NEXT:-55990}"
    PGPORT_NEXT=$((sport + 1))
    local ssock; ssock="$(sock_of "$sdata")"
    mkdir -p "$ssock"
    apply_logging_conf "$sdata/postgresql.conf"
    repl_conf "$sdata" \
        "port=$sport" \
        "unix_socket_directories='$ssock'" \
        "listen_addresses='localhost'" \
        "hot_standby=on"
    PGPORT="$sport"; PGSOCK="$ssock"; PGDATA_DIR="$sdata"
}

# repl_wait_streaming <primary_port> [expected_count] [timeout_s]
# Poll pg_stat_replication on the primary until at least <expected_count> (default
# 1) walsenders are attached, or the timeout (default 30s) elapses. Return 0/1.
repl_wait_streaming() {
    local port="$1" want="${2:-1}" timeout="${3:-30}"
    local deadline=$((SECONDS + timeout)) n
    while [ "$SECONDS" -lt "$deadline" ]; do
        n="$(qval "$port" "SELECT count(*) FROM pg_stat_replication")"
        if [ -n "$n" ] && [ "$n" -ge "$want" ] 2>/dev/null; then return 0; fi
        sleep 1
    done
    return 1
}

# repl_wait_standby_ready <standby_datadir> <standby_port> [timeout_s]
# Poll until a read-only query succeeds on the standby (hot standby has finished
# reaching a consistent state), or the timeout (default 30s) elapses. Return 0/1.
repl_wait_standby_ready() {
    local sdata="$1" port="$2" timeout="${3:-30}"
    local deadline=$((SECONDS + timeout))
    while [ "$SECONDS" -lt "$deadline" ]; do
        [ "$(qval "$port" "SELECT 1")" = "1" ] && return 0
        sleep 1
    done
    log "  standby at $sdata (port $port) never became query-ready"
    return 1
}

# repl_wait_catchup <primary_port> [timeout_s]
# Wait until every pg_stat_replication row reports state='streaming' (all
# attached standbys have caught up to live streaming), bounded by the timeout
# (default 30s). Return 0/1.
repl_wait_catchup() {
    local port="$1" timeout="${2:-30}"
    local deadline=$((SECONDS + timeout)) total behind
    while [ "$SECONDS" -lt "$deadline" ]; do
        total="$(qval "$port" "SELECT count(*) FROM pg_stat_replication")"
        behind="$(qval "$port" \
            "SELECT count(*) FROM pg_stat_replication WHERE state <> 'streaming'")"
        if [ -n "$total" ] && [ "$total" -ge 1 ] 2>/dev/null \
           && [ "${behind:-1}" = "0" ]; then return 0; fi
        sleep 1
    done
    return 1
}

# repl_primary_up <datadir> [wal_level]  — init, configure for replication, and
# start a primary. wal_level defaults to 'replica' (pass 'logical' for logical
# decoding / pub-sub). Adds replication + local pg_hba trust lines, tracks the
# cluster for teardown, and leaves PGPORT/PGSOCK/PGDATA_DIR pointing at it.
repl_primary_up() {
    local d="$1" level="${2:-replica}"
    init_cluster "$d"
    repl_conf "$d" \
        "wal_level=$level" \
        "max_wal_senders=12" \
        "max_replication_slots=12" \
        "hot_standby=on" \
        "wal_log_hints=on" \
        "wal_keep_size=64MB" \
        "log_replication_commands=on"
    {
        echo "host    replication  postgres  127.0.0.1/32  trust"
        echo "host    all          postgres  127.0.0.1/32  trust"
        echo "local   replication  postgres                trust"
    } >> "$d/pg_hba.conf"
    repl_track "$d"
    start_cluster "$d"
}

# repl_standby_up <primary_datadir> <primary_port> <standby_datadir> [pg_basebackup args...]
# Base-backup a standby, start it, and wait for it to become query-ready. Tracks
# it for teardown; leaves PGPORT/PGSOCK/PGDATA_DIR pointing at the standby.
# Returns non-zero if the backup or the hot-standby handshake never came up.
repl_standby_up() {
    local pdata="$1" pport="$2" sdata="$3"; shift 3
    repl_basebackup_standby "$pdata" "$pport" "$sdata" "$@" || return 1
    local sport="$PGPORT"
    repl_track "$sdata"
    start_cluster "$sdata"
    repl_wait_standby_ready "$sdata" "$sport" 30 || return 1
    PGPORT="$sport"
}

# --- scenario lifecycle -----------------------------------------------------
# A scenario registers each cluster it starts with repl_track; the EXIT trap set
# by repl_begin then stops them all (immediate) and wipes the scratch subdir,
# even on error. Captures are copied into $CAPS beforehand, so teardown is free
# to delete the datadirs.
REPL_CLUSTERS=()
repl_track() { REPL_CLUSTERS+=("$1"); }

repl_teardown() {
    local d
    for d in "${REPL_CLUSTERS[@]:-}"; do
        [ -n "${d:-}" ] && stop_cluster "$d" immediate
    done
    [ -n "${SCEN_DIR:-}" ] && rm -rf "$SCEN_DIR" 2>/dev/null
    return 0
}

# repl_begin <scenario_tag>  — standard preamble: tool-path/OUTDIR/CAPS setup, a
# private scratch root ($SCEN_DIR), a fresh cluster registry, and the teardown
# trap. Sets globals SCEN, SCEN_DIR.
repl_begin() {
    SCEN="$1"
    driver_env_setup
    SCEN_DIR="$OUTDIR/$SCEN"
    rm -rf "$SCEN_DIR"; mkdir -p "$SCEN_DIR"
    REPL_CLUSTERS=()
    trap 'repl_teardown' EXIT
    log "=== scenario $SCEN (scratch $SCEN_DIR) ==="
}

# repl_capture <capture_tag> <datadir>  — copy a cluster's jsonlog into $CAPS as
# tier4__<capture_tag>.json (the coverage join's <tier>__<scenario> naming). A
# scenario with several clusters calls this once per cluster so no fired site is
# lost (e.g. _primary / _standby / _cascade suffixes).
repl_capture() {
    local tag="$1" datadir="$2" src
    src="$(jsonlog_of "$datadir")"
    if [ -n "$src" ] && [ -f "$src" ]; then
        cp "$src" "$CAPS/tier4__${tag}.json"
        log "  captured $(wc -l <"$src") lines -> tier4__${tag}.json"
    else
        log "  no jsonlog for $tag (cluster may not have booted)"
    fi
}
