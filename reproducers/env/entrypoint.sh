#!/usr/bin/env bash
#
# Entrypoint for the Tier 3-4 env-variant image. Runs the selected scenario(s)
# from env-run.sh and leaves the captured jsonlog under $OUTDIR (a mounted
# volume). The catalog join runs on the host afterwards (env-coverage.py), so no
# catalog is needed inside the image — this just captures.
set -euo pipefail

export LOGGING_CONF="${LOGGING_CONF:-/etc/logref/logging.conf}"
export PGBIN="${PGBIN:-/usr/local/pgsql/bin}"
export OUTDIR="${OUTDIR:-/capture}"
mkdir -p "$OUTDIR"

# SCENARIO=all runs the whole set; otherwise restrict env-run.sh to that name.
if [ "${SCENARIO:-all}" != "all" ]; then
    export ONLY="$SCENARIO"
fi

exec /opt/logref-repro/env-run.sh
