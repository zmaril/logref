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
    PGSOCK="$(dirname "$datadir")/sock-$(basename "$datadir")"
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
