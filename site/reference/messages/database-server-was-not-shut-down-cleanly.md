---
message: "database server was not shut down cleanly"
slug: database-server-was-not-shut-down-cleanly
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:539"
reproduced: false
---

# `database server was not shut down cleanly`

## What it means

`pg_resetwal` found that the server was not shut down cleanly before the tool was run. `pg_resetwal` rewrites WAL control state and is only safe on a cleanly stopped cluster, since resetting WAL after an unclean stop can discard un-replayed changes.

## When it happens

It happens when you run `pg_resetwal` against a data directory whose control file shows the server crashed or was killed rather than stopped cleanly.

## How to fix

Prefer starting the server normally so it performs crash recovery, then stopping it cleanly, before considering `pg_resetwal` at all. `pg_resetwal` is a last resort that can cause data loss; only force it (`-f`) when recovery is impossible and you accept that risk. Take a filesystem-level backup of the data directory first.

## Example

*Illustrative* — resetting WAL after an unclean stop.

```text
pg_resetwal: error: database server was not shut down cleanly
```

## Related

- [database cluster state problem](./database-cluster-state-problem.md)
- [database cluster is not compatible](./database-cluster-is-not-compatible.md)
