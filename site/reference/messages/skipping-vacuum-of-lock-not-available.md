---
message: "skipping vacuum of \"%s\" --- lock not available"
slug: skipping-vacuum-of-lock-not-available
passthrough: false
api: [ereport]
level: [WARNING]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_LOCK_NOT_AVAILABLE
    code: "55P03"
call_sites:
  - "postgres/src/backend/commands/vacuum.c:833"
  - "postgres/src/backend/commands/vacuum.c:934"
reproduced: false
---

# `skipping vacuum of "%s" --- lock not available`

## What it means

An autovacuum or maintenance vacuum could not acquire the lock it needed on a relation, so it skipped vacuuming that relation this cycle rather than waiting.

## When it happens

It is emitted at WARNING when vacuum runs in a non-blocking mode and the table is locked by concurrent DDL or another maintenance operation when vacuum tried to start.

## Is this a problem?

Usually transient — a later cycle vacuums the table once the conflicting lock clears. If a table is skipped repeatedly, it can accumulate bloat and delay freezing, so find the long-held lock via `pg_locks` and the blocking session. Watch for wraparound risk on persistently skipped tables.

## Example

*Illustrative* — vacuum skipping a locked table.

```text
WARNING:  skipping vacuum of "public.events" --- lock not available
```

## Related

- [skipping analyze of --- lock not available](./skipping-analyze-of-lock-not-available.md)
- [aborting because lock on relation is not available](./aborting-because-lock-on-relation-is-not-available.md)
