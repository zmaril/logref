# LogRef reproducer — base image.
#
# Builds PostgreSQL from source at HEAD (master), NOT a released tag, so the
# log strings this cluster emits line up character-for-character with the
# HEAD-extracted catalog. This is the "Validate" stage of the LogRef design
# (notes/design.md §4): run the real database, drive it through as many of its
# log call sites as possible, and capture the output with source-location
# provenance.
#
# The cluster is configured to emit `jsonlog`, which tags every line with
# `file_name` + `file_line_num` (the __FILE__/__LINE__ of the ereport/elog call
# site) plus SQLSTATE and severity — exactly the fields we join against the
# catalog's `path`/`line`.

FROM debian:bookworm-slim AS build

# Build dependencies for a from-source Postgres. libreadline/zlib/openssl/icu
# are the usual extras; the rest are the compiler toolchain. We keep the build
# lean with a shallow clone and a stripped install.
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates git gcc make bison flex perl pkg-config \
        libreadline-dev zlib1g-dev libicu-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

ARG PG_REPO=https://github.com/postgres/postgres.git
# Pin nothing to a released tag: clone the tip of master. Override PG_REF only to
# reproduce a specific historical HEAD; the default follows master.
ARG PG_REF=master
ENV PG_PREFIX=/usr/local/pgsql

RUN git clone --depth 1 --branch "${PG_REF}" "${PG_REPO}" /tmp/postgres \
    && cd /tmp/postgres \
    && git rev-parse HEAD > /pg-head-commit.txt \
    && ./configure --prefix="${PG_PREFIX}" --with-openssl \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf /tmp/postgres

# ----------------------------------------------------------------------------
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
        libreadline8 zlib1g libicu72 libssl3 locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV PG_PREFIX=/usr/local/pgsql
ENV PATH="${PG_PREFIX}/bin:${PATH}"
ENV PGDATA=/var/lib/postgresql/data
ENV LANG=en_US.UTF-8

COPY --from=build ${PG_PREFIX} ${PG_PREFIX}
COPY --from=build /pg-head-commit.txt /pg-head-commit.txt

# Non-root postgres user owns the data dir.
RUN groupadd -r postgres && useradd -r -g postgres -m -d /var/lib/postgresql postgres \
    && mkdir -p "${PGDATA}" && chown -R postgres:postgres /var/lib/postgresql

# The logging configuration that makes reproduction ground-truthed. Appended to
# postgresql.conf by the entrypoint after initdb.
COPY base/logging.conf /etc/logref/logging.conf

USER postgres
WORKDIR /var/lib/postgresql

# initdb is done at container start (needs a writable volume). The reproducer
# driver (reproducers/run.sh) invokes psql against the running cluster; this
# image just gives you a HEAD Postgres wired for maximum log provenance.
CMD ["bash", "-lc", "\
    initdb -D \"$PGDATA\" -U postgres --locale=en_US.UTF-8 && \
    cat /etc/logref/logging.conf >> \"$PGDATA/postgresql.conf\" && \
    exec postgres -D \"$PGDATA\" \
    "]
