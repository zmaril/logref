#!/usr/bin/env bash
#
# LogRef reproducer driver — the Validate stage.
#
# Boots a HEAD Postgres wired for maximum log provenance, runs every scenario in
# scenarios/ against it, captures the jsonlog output, and joins captured
# file:line locations against the extracted catalog to produce a coverage report.
#
# Two modes:
#   --docker   build reproducers/base/Dockerfile and run the cluster in a
#              container (the shippable path).
#   --direct   use an already-built Postgres from $PGBIN (or PATH) and run the
#              cluster in a scratch dir on the host (how we MEASURE when
#              Docker-in-Docker is unavailable). This is the default.
#
# Env:
#   PGBIN        dir with initdb/postgres/psql (default: from PATH)
#   CATALOG      path to the catalog JSONL (required)
#   WORKDIR      scratch dir for the cluster + captured logs (default: mktemp)
#   LOG_LEVEL    log_min_messages override (default: debug1; try debug5)
#
# Usage:
#   CATALOG=/path/pg-log-catalog.jsonl reproducers/run.sh --direct

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="direct"
for arg in "$@"; do
    case "$arg" in
        --docker) MODE="docker" ;;
        --direct) MODE="direct" ;;
        *) echo "unknown arg: $arg" >&2; exit 2 ;;
    esac
done

: "${CATALOG:?set CATALOG to the catalog JSONL path}"
WORKDIR="${WORKDIR:-$(mktemp -d)}"
LOG_LEVEL="${LOG_LEVEL:-debug1}"
PGDATA="$WORKDIR/pgdata"
LOGDIR="$PGDATA/log"
REPORT="$HERE/coverage-report.md"

log() { printf '[run] %s\n' "$*" >&2; }

apply_logging_conf() {
    # Append the shared logging config, then pin log_min_messages to LOG_LEVEL.
    cat "$HERE/base/logging.conf" >> "$1"
    {
        echo ""
        echo "# --- driver override ---"
        echo "log_min_messages = $LOG_LEVEL"
        echo "log_min_error_statement = $LOG_LEVEL"
    } >> "$1"
}

run_scenarios() {
    # $1 = psql invocation as an array name is awkward in bash; pass a command
    # prefix string that already targets the running cluster.
    local psql_cmd="$1"
    for f in "$HERE"/scenarios/*.sql; do
        log "scenario: $(basename "$f")"
        # ON_ERROR_STOP off on purpose: almost every statement errors, and each
        # error is exactly the log site we want to fire. -q keeps stderr quiet;
        # the jsonlog file is the real capture.
        $psql_cmd -v ON_ERROR_STOP=0 -q -f "$f" >/dev/null 2>&1 || true
    done
    # A clean disconnect + checkpoint so shutdown/checkpoint LOG sites fire.
    $psql_cmd -c "CHECKPOINT;" >/dev/null 2>&1 || true
}

direct_mode() {
    local bin="${PGBIN:-}"
    if [ -n "$bin" ]; then PATH="$bin:$PATH"; fi
    command -v initdb >/dev/null || { log "initdb not on PATH; set PGBIN"; exit 3; }
    log "Postgres: $(postgres --version)"
    local commit="unknown"
    [ -f "${PGSRC:-}/.git/HEAD" ] && commit="$(git -C "$PGSRC" rev-parse HEAD 2>/dev/null || echo unknown)"

    log "initdb -> $PGDATA"
    initdb -D "$PGDATA" -U postgres --locale=C >/dev/null
    apply_logging_conf "$PGDATA/postgresql.conf"
    echo "port = 55999" >> "$PGDATA/postgresql.conf"
    echo "unix_socket_directories = '$WORKDIR'" >> "$PGDATA/postgresql.conf"

    log "starting cluster"
    pg_ctl -D "$PGDATA" -l "$WORKDIR/server.log" -w start >/dev/null
    trap 'pg_ctl -D "$PGDATA" -m fast stop >/dev/null 2>&1 || true' EXIT

    local psql_cmd="psql -h $WORKDIR -p 55999 -U postgres -d postgres"
    run_scenarios "$psql_cmd"

    log "stopping cluster (fires shutdown/checkpoint LOG sites)"
    pg_ctl -D "$PGDATA" -m fast stop >/dev/null 2>&1 || true
    trap - EXIT

    report "$commit"
}

docker_mode() {
    command -v docker >/dev/null || { log "docker not available"; exit 3; }
    local img="logref-reproducer:head"
    log "building image (this compiles Postgres from HEAD — slow)"
    docker build -t "$img" -f "$HERE/base/Dockerfile" "$HERE"
    local cid
    cid="$(docker run -d -v "$WORKDIR:/capture" "$img")"
    trap 'docker rm -f "$cid" >/dev/null 2>&1 || true' EXIT
    log "waiting for cluster"
    for _ in $(seq 1 30); do
        if docker exec "$cid" pg_isready -U postgres >/dev/null 2>&1; then break; fi
        sleep 2
    done
    local commit
    commit="$(docker exec "$cid" cat /pg-head-commit.txt 2>/dev/null || echo unknown)"
    for f in "$HERE"/scenarios/*.sql; do
        log "scenario: $(basename "$f")"
        docker exec -i "$cid" psql -U postgres -d postgres -v ON_ERROR_STOP=0 -q \
            < "$f" >/dev/null 2>&1 || true
    done
    docker exec "$cid" psql -U postgres -d postgres -c "CHECKPOINT;" >/dev/null 2>&1 || true
    # Copy the jsonlog out of the container.
    docker cp "$cid:/var/lib/postgresql/data/log/." "$LOGDIR" 2>/dev/null || \
        docker exec "$cid" bash -lc 'cat $PGDATA/log/*.json' > "$WORKDIR/reproducer.json"
    docker rm -f "$cid" >/dev/null 2>&1 || true
    trap - EXIT
    report "$commit"
}

report() {
    local commit="$1"
    mkdir -p "$LOGDIR"
    local logs=()
    while IFS= read -r -d '' f; do logs+=("$f"); done \
        < <(find "$WORKDIR" -name '*.json' -path '*log*' -print0 2>/dev/null)
    [ ${#logs[@]} -eq 0 ] && logs=("$WORKDIR/reproducer.json")
    log "captured jsonlog: ${logs[*]}"
    python3 "$HERE/coverage.py" \
        --catalog "$CATALOG" \
        --logs "${logs[@]}" \
        --out "$REPORT" \
        --commit "$commit"
    log "report written to $REPORT"
}

case "$MODE" in
    direct) direct_mode ;;
    docker) docker_mode ;;
esac
