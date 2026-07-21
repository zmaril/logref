# LogRef reproducer — Tier 3-4 env-variant image.
#
# Extends the base image (which compiles Postgres from HEAD) with the extra
# runtime bits the hostile-environment scenarios need, and ships the Tier 3-4
# harness. One parametrized image drives every env variant: pick a scenario (or
# "all") with the SCENARIO build/run arg; the entrypoint stands up the scratch
# cluster(s) that scenario needs and leaves the captured jsonlog under /capture.
#
# Build the base first (it is the slow, from-source stage), then this:
#
#   docker build -t logref-reproducer:head -f reproducers/base/Dockerfile reproducers
#   docker build -t logref-reproducer:env  -f reproducers/env/Dockerfile  reproducers
#   docker run --rm -e SCENARIO=replication -v "$PWD/cap:/capture" logref-reproducer:env
#
# Then join the captures against the catalog on the host:
#   python3 reproducers/env-coverage.py --catalog <catalog.jsonl> \
#       --caps ./cap/caps --baseline <tier12.json> \
#       --out reproducers/coverage-report.md --json-out reproducers/reproduced-sites.json
#
# Notes on capability edges (honest, per the design's "honest capability edges"):
#   * The disk-full scenario mounts a tmpfs and is skipped unless the container
#     runs with mount privileges (--privileged or CAP_SYS_ADMIN). Everything
#     else runs in an ordinary container.
#   * OOM needs a memory cgroup cap (`docker run -m`) plus an allocation that
#     actually fails; it is not attempted here.

ARG BASE=logref-reproducer:head
FROM ${BASE}

# openssl: generate the self-signed server cert the auth/SSL scenario needs.
# procps: pkill, used by the crash-recovery scenario to kill surviving backends.
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
        openssl procps ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# The harness. logging.conf is shared with the base image; point lib.sh at the
# copy the base image already installed under /etc/logref.
RUN mkdir -p /opt/logref-repro
COPY --chown=postgres:postgres lib.sh env-run.sh env-coverage.py /opt/logref-repro/
COPY --chown=postgres:postgres env/entrypoint.sh /opt/logref-repro/entrypoint.sh
RUN chmod +x /opt/logref-repro/env-run.sh /opt/logref-repro/entrypoint.sh

ENV PG_PREFIX=/usr/local/pgsql
ENV PATH="${PG_PREFIX}/bin:${PATH}"
ENV PGBIN="${PG_PREFIX}/bin"
ENV LOGGING_CONF=/etc/logref/logging.conf
# Which scenario(s) to run: a name from env-run.sh's ALL list, or "all".
ENV SCENARIO=all
ENV OUTDIR=/capture
ENV LOG_LEVEL=debug5

USER postgres
WORKDIR /var/lib/postgresql
VOLUME ["/capture"]
ENTRYPOINT ["/opt/logref-repro/entrypoint.sh"]
