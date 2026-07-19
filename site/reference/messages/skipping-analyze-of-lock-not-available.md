---
message: "skipping analyze of \"%s\" --- lock not available"
slug: skipping-analyze-of-lock-not-available
passthrough: false
api: [ereport]
level: [WARNING]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_LOCK_NOT_AVAILABLE
    code: "55P03"
call_sites:
  - "postgres/src/backend/commands/vacuum.c:854"
  - "postgres/src/backend/commands/vacuum.c:939"
reproduced: false
---

# `skipping analyze of "%s" --- lock not available`

## What it means

An autovacuum or maintenance analyze could not acquire the lock it needed on a relation, so it skipped analyzing that relation this time rather than waiting.

## When it happens

It is emitted at WARNING when analyze runs in a non-blocking mode and the table is locked by another session (for example under an exclusive lock from DDL) at the moment analyze tried to start.

## Is this a problem?

This is usually transient — the next analyze cycle will pick the table up once the conflicting lock is released. If a table is repeatedly skipped, find the long-held lock (query `pg_locks`) and the session holding it. Stale statistics can degrade plans, so investigate persistent skips.

## Example

*Illustrative* — analyze skipping a busy table.

```text
WARNING:  skipping analyze of "public.orders" --- lock not available
```

## Related

- [skipping vacuum of --- lock not available](./skipping-vacuum-of-lock-not-available.md)
- [aborting because lock on relation is not available](./aborting-because-lock-on-relation-is-not-available.md)
