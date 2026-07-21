#!/usr/bin/env bash
#
# LogRef reproducer driver -- FRONTEND client-tool log sites (scenarios 66-69).
#
# The Tier 1-4 drivers (run.sh / env-run.sh) reach *backend* sites: they boot a
# cluster and capture jsonlog, which carries file_name/file_line_num so the
# catalog join is a file:line match.  Frontend tools are different -- pg_dump,
# pgbench, clusterdb & co. call pg_log_error / pg_fatal, which print plain text
# to stderr ("progname: error: <message>") with NO source location.  The jsonlog
# join can never see them.
#
# So we reproduce them the only honest way: RUN each tool straight into a real
# option-parsing / value-validation error and capture its stderr.  A companion
# matcher (frontend-coverage.py) attributes each captured line to the UNIQUE
# frontend catalog site whose printf format string matches it, constrained to
# that tool's own source file(s) plus the shared fe_utils/common helpers.  The
# site genuinely fired at runtime; it is identified by message, not file:line.
#
# We deliberately target errors that need NO running server -- option parsing
# and value validation -- because they are deterministic and map cleanly.  A
# handful of connection-dependent errors are captured too (they simply won't
# match distinctively, and the matcher drops them honestly).
#
# Env (all optional; mirrors env-run.sh via lib.sh's driver_env_setup):
#   PGBIN  dir with the client tools   (put on PATH by driver_env_setup)
#   PGLIB  dir with libpq.so           (exported as LD_LIBRARY_PATH)
#   OUTDIR scratch root                (default: a fresh mktemp -d)
#   CAPS   capture dir                 (default: $OUTDIR/caps); frontend.txt is
#          written there. Point the matcher (frontend-coverage.py --caps) at the
#          same file.
#
# Output: $CAPS/frontend.txt -- "### tool=<name>" markers interleaved with each
# command's stderr.  Feed it to frontend-coverage.py.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/lib.sh"
# driver_env_setup unconditionally sets CAPS="$OUTDIR/caps"; remember a
# caller-provided CAPS so an explicit capture dir still wins after the call.
_CAPS_WANT="${CAPS:-}"
driver_env_setup                      # PGBIN/PGLIB path + OUTDIR/CAPS
CAPS="${_CAPS_WANT:-$CAPS}"
mkdir -p "$CAPS"
OUTFILE="$CAPS/frontend.txt"
: >"$OUTFILE"                         # truncate a previous run
TD="$CAPS/throwaway"                  # scratch target dirs/files the tools want
rm -rf "$TD"; mkdir -p "$TD"

# The ONE shared helper.  Every scenario body is just a flat list of `cap_tool`
# data lines -- all structure (marker + stderr redirect + never-fail) lives here,
# so there is no cross-scenario boilerplate to keep in sync.
cap_tool() {                          # $1=tool basename, rest=args
    local tool="$1"; shift
    # Marker carries both the tool (for candidate scoping) and the exact argv
    # (for an honest "trigger command" in the report). $TD paths are abbreviated.
    printf '### tool=%s argv=%s %s\n' "$tool" "$tool" "${*//$TD/\$TD}" >>"$OUTFILE"
    "$PGBIN/$tool" "$@" </dev/null >>"$OUTFILE" 2>&1 || true
}

# ---------------------------------------------------------------------------
# Server-dependent triggers.  A second family of frontend sites fires only once
# the tool has a LIVE connection: object-filter validation (pg_dump --table=X
# against the real catalog), psql meta-command execution, and the scripts'
# per-database processing.  These are unreachable by option/value parsing alone,
# so the no-cluster pass never sees them.
#
# The harness (finalize step / a manual run) points us at a booted cluster via
# FE_PGHOST + FE_PGPORT (a unix-socket dir or host) with FE_PGUSER / FE_PGDB.
# When no cluster is reachable we skip every server trigger HONESTLY -- the
# option/value scenarios above still run and still reproduce their sites.
# ---------------------------------------------------------------------------
FE_PGHOST="${FE_PGHOST:-}"
FE_PGPORT="${FE_PGPORT:-}"
FE_PGUSER="${FE_PGUSER:-postgres}"
FE_PGDB="${FE_PGDB:-testdb}"
SERVER_OK=0
if [ -n "$FE_PGHOST" ] && [ -n "$FE_PGPORT" ] && \
   "$PGBIN/psql" -h "$FE_PGHOST" -p "$FE_PGPORT" -U "$FE_PGUSER" -d "$FE_PGDB" \
        -tAc 'select 1' >/dev/null 2>&1; then
    SERVER_OK=1
    log "live cluster at $FE_PGHOST:$FE_PGPORT db=$FE_PGDB -- running server triggers"
else
    log "no live cluster (set FE_PGHOST/FE_PGPORT) -- skipping server-dependent triggers"
fi

# cap_conn: exactly like cap_tool, but injects the -h/-p/-U connection flags
# right after the tool name so the invocation targets the live cluster.  The
# connection string is abbreviated to '@CONN' in the printed marker so the real
# socket path never clutters the reported trigger command.  Caller supplies the
# database the usual way for that tool ($FE_PGDB as a trailing positional, or
# `-d $FE_PGDB` for psql).
cap_conn() {
    [ "$SERVER_OK" = 1 ] || return 0
    local tool="$1"; shift
    printf '### tool=%s argv=%s @CONN %s\n' "$tool" "$tool" "${*//$TD/\$TD}" >>"$OUTFILE"
    "$PGBIN/$tool" -h "$FE_PGHOST" -p "$FE_PGPORT" -U "$FE_PGUSER" "$@" \
        </dev/null >>"$OUTFILE" 2>&1 || true
}

# ---------------------------------------------------------------------------
# 66 -- pg_dump / pg_restore / pg_dumpall / pg_upgrade.
# Mutually-exclusive dump options, bad formats, bad compression, bad values.
# ---------------------------------------------------------------------------
scenario_66_dump() {
    cap_tool pg_dump -s -a
    cap_tool pg_dump --format=bogus
    cap_tool pg_dump --compress=nope
    cap_tool pg_dump -Z bad
    cap_tool pg_dump -j abc
    cap_tool pg_dump --rows-per-insert=abc
    cap_tool pg_dump --if-exists
    cap_tool pg_dump --on-conflict-do-nothing
    cap_tool pg_dump --include-foreign-data=srv -s
    cap_tool pg_dump --clean -a
    cap_tool pg_dump --statistics-only --no-statistics
    cap_tool pg_dump --extra-float-digits=99

    cap_tool pg_restore
    cap_tool pg_restore -F x /dev/null
    cap_tool pg_restore --if-exists
    cap_tool pg_restore -j abc /dev/null

    cap_tool pg_dumpall -r -t
    cap_tool pg_dumpall --format=c
    cap_tool pg_dumpall -g -r

    cap_tool pg_upgrade -j abc
    cap_tool pg_upgrade

    # -- server-dependent: object-filter validation against the live catalog.
    # A non-matching include pattern is a hard error; strict-names swaps the
    # unqualified "no matching X were found" for the per-pattern variant.
    cap_conn pg_dump --table=nope "$FE_PGDB"
    cap_conn pg_dump --table=nope --strict-names "$FE_PGDB"
    cap_conn pg_dump --schema=nope "$FE_PGDB"
    cap_conn pg_dump --schema=nope --strict-names "$FE_PGDB"
    cap_conn pg_dump --extension=nope "$FE_PGDB"
    cap_conn pg_dump --extension=nope --strict-names "$FE_PGDB"
    cap_conn pg_dump --include-foreign-data=nope "$FE_PGDB"
}

# ---------------------------------------------------------------------------
# 67 -- physical/backup tools.  Bad output formats, bad units, bad tablespace
# maps, bad checksum/compression algorithms, mutually-exclusive slot options.
# ---------------------------------------------------------------------------
scenario_67_backup() {
    cap_tool pg_basebackup
    cap_tool pg_basebackup --format=x
    cap_tool pg_basebackup -D "$TD/bb1" --compress=nope
    cap_tool pg_basebackup -D "$TD/bb2" -c bad
    cap_tool pg_basebackup -D "$TD/bb3" -X bad
    cap_tool pg_basebackup -D "$TD/bb4" -T badmap
    cap_tool pg_basebackup -D "$TD/bb5" --max-rate=abc
    cap_tool pg_basebackup -D "$TD/bb6" -j abc

    cap_tool pg_receivewal
    cap_tool pg_receivewal --create-slot --drop-slot
    cap_tool pg_receivewal --synchronous --no-sync
    cap_tool pg_receivewal -D "$TD/rw" --compression-method=lz4 --compress=abc

    cap_tool pg_recvlogical
    cap_tool pg_recvlogical --create-slot --drop-slot -S x
    cap_tool pg_recvlogical --drop-slot --startpos=0/0 -S x
    cap_tool pg_recvlogical --endpos=0/0 --drop-slot -S x
    cap_tool pg_recvlogical --start -S x

    cap_tool pg_rewind
    cap_tool pg_rewind --source-pgdata=/x --source-server=y --target-pgdata=/z

    cap_tool pg_combinebackup
    cap_tool pg_combinebackup -o "$TD/cb1" -T badmap "$TD/a" "$TD/b"
    cap_tool pg_combinebackup --manifest-checksums=bad -o "$TD/cb2" "$TD/a" "$TD/b"

    cap_tool pg_verifybackup
    cap_tool pg_verifybackup -F bad "$TD/vb"

    cap_tool pg_waldump --start=bad
    cap_tool pg_waldump -b abc
    cap_tool pg_waldump -R badrel
    cap_tool pg_waldump -F badfork
    cap_tool pg_waldump -n abc

    cap_tool pg_checksums
    cap_tool pg_checksums -D "$TD/nocluster"

    cap_tool pg_amcheck --heapallindexed

    # -- server-dependent: pg_amcheck connects, finds amcheck is not installed
    # in the target DB (warning), then reports it has nothing to verify (fatal).
    cap_conn pg_amcheck "$FE_PGDB"
}

# ---------------------------------------------------------------------------
# 68 -- pgbench + psql.  Builtin/value/mode errors (pgbench) and startup /
# printing-parameter errors (psql).  Meta-command errors need a live server and
# are expected to miss here; they are captured for honesty, not credit.
# ---------------------------------------------------------------------------
scenario_68_bench_psql() {
    cap_tool pgbench -c abc
    cap_tool pgbench -T abc
    cap_tool pgbench -s abc
    cap_tool pgbench -M bad
    cap_tool pgbench -b nosuch
    cap_tool pgbench --builtin=nosuch
    cap_tool pgbench --partition-method=bad
    cap_tool pgbench -i -S
    cap_tool pgbench --sampling-rate=abc
    cap_tool pgbench --partitions=abc

    cap_tool psql -P bad=val -l
    cap_tool psql -P format=nonsense -l
    cap_tool psql --csv --html -l
    cap_tool psql -c '\badcmd'

    # -- server-dependent: pgbench runs against a database with no pgbench_*
    # tables and fails counting the (missing) pgbench_branches table.  ($FE_PGDB
    # is seeded with ordinary tables only, never `pgbench -i`-initialized.)
    cap_conn pgbench "$FE_PGDB"

    # NB: psql meta-command validation errors (\pset/\watch/\if/\elif/\else/
    # \endif/...) DO fire once connected, but psql prints them BARE -- just
    # "\pset: allowed ..." with no "psql: error:" progname/level prefix -- so
    # the matcher's `progname: level:` line filter cannot recognize them and
    # they can never be attributed by message.  We therefore don't drive them
    # here: they would only add unattributable noise.  (The startup-time
    # variants, e.g. `psql -P format=nonsense`, DO carry the prefix and are
    # already covered by the no-server pass above.)
}

# ---------------------------------------------------------------------------
# 69 -- scripts (clusterdb/vacuumdb/reindexdb/createdb/dropdb/createuser/
# dropuser) + initdb + pg_ctl.  All-vs-specific, bad values, bad encodings.
# ---------------------------------------------------------------------------
scenario_69_scripts() {
    cap_tool clusterdb --all mydb
    cap_tool clusterdb --all --table=t

    cap_tool vacuumdb --all mydb
    cap_tool vacuumdb -n s -t t
    cap_tool vacuumdb -j abc
    cap_tool vacuumdb -P abc
    cap_tool vacuumdb --full --analyze-only

    cap_tool reindexdb --all mydb
    cap_tool reindexdb -j abc
    cap_tool reindexdb -s -j 2

    cap_tool createdb -E NOSUCHENC testdb
    cap_tool createdb a b c

    cap_tool dropdb
    cap_tool dropdb a b c

    cap_tool createuser -c abc foo
    cap_tool createuser a b c

    cap_tool dropuser
    cap_tool dropuser a b c

    cap_tool initdb --wal-segsize=7
    cap_tool initdb --auth=bogus
    cap_tool initdb --nosync --sync-only
    cap_tool initdb -D "$TD/id" --set foo

    cap_tool pg_ctl badaction
    cap_tool pg_ctl start -D "$TD/nodir" -w

    # -- server-dependent: the create/drop wrappers report the server's refusal
    # through their own distinctive "<action> failed: %s" sites (the %s carries
    # the server text, the literal prefix is the frontend site).  Uses objects
    # the harness seeds: db "$FE_PGDB" and role "alice" already exist.
    cap_conn createdb "$FE_PGDB"
    cap_conn createuser alice
    cap_conn dropdb nosuchdb_xyz
    cap_conn dropuser nosuchrole_xyz
    # reindexdb --schema drives the parallel-slot path -> "processing of
    # database ... failed" (a shared fe_utils site), distinct from the ambiguous
    # bare "query failed" that --table/--index take.
    cap_conn reindexdb --schema=nope "$FE_PGDB"
}

log "capturing frontend errors -> $OUTFILE"
scenario_66_dump
scenario_67_backup
scenario_68_bench_psql
scenario_69_scripts
log "done: $(grep -c '^### tool=' "$OUTFILE") invocations, $(wc -l <"$OUTFILE") lines"
