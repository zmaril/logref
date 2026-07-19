---
message: "no data directory specified"
slug: no-data-directory-specified
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2654"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:526"
  - "postgres/src/bin/pg_controldata/pg_controldata.c:163"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:376"
reproduced: false
---

# `no data directory specified`

## What it means

A server-side tool that needs to know which data directory to operate on was run without one. The data directory is not optional for these tools: `initdb`, the server, and the standalone utilities all need an explicit `-D`/`--pgdata` path (or the `PGDATA` environment variable) to know where the cluster lives.

## When it happens

Running `initdb`, `postgres`, or a related tool with neither a `-D`/`--pgdata` argument nor `PGDATA` set in the environment.

## How to fix

Pass the data directory explicitly — `-D /path/to/data` (or `--pgdata=`) — or export `PGDATA` before running the tool. For a new cluster this is the directory `initdb` will populate; for an existing one it must point at the directory that already holds `PG_VERSION` and the cluster files.

## Example

*Illustrative* — initdb run with no data directory.

```sh
initdb            # error: no data directory specified
initdb -D /var/lib/pgsql/data
```

## Related

- [could not determine current directory](./could-not-determine-current-directory.md)
- [data directory is of wrong version](./data-directory-is-of-wrong-version.md)
