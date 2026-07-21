---
message: "cannot reindex system catalogs concurrently"
slug: cannot-reindex-system-catalogs-concurrently
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:3290"
  - "postgres/src/backend/commands/indexcmds.c:3801"
  - "postgres/src/backend/commands/indexcmds.c:3931"
reproduced: false
---

# `cannot reindex system catalogs concurrently`

## What it means

`REINDEX ... CONCURRENTLY` was requested for a system catalog. The placeholder-free message reflects a hard restriction: the concurrent reindex path relies on machinery that cannot be used safely on the catalogs the server itself depends on, so system catalogs may only be reindexed with a plain (locking) `REINDEX`.

## When it happens

Running `REINDEX (CONCURRENTLY) SYSTEM`, `REINDEX INDEX CONCURRENTLY` on a `pg_catalog` index, or `REINDEX TABLE CONCURRENTLY` on a system catalog table.

## How to fix

Reindex system catalogs without `CONCURRENTLY` — a plain `REINDEX SYSTEM` or `REINDEX TABLE pg_catalog.<name>` — accepting the lock it takes, ideally during a maintenance window. Concurrent reindex remains available for ordinary user indexes.

## Example

*Illustrative* — a concurrent reindex of catalogs.

```sql
REINDEX (CONCURRENTLY) SYSTEM;  -- cannot reindex system catalogs concurrently
```

## Related

- [cannot access temporary indexes of other sessions](./cannot-access-temporary-indexes-of-other-sessions.md)
- [could not open parent table of index](./could-not-open-parent-table-of-index.md)
