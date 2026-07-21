---
message: "aborting because lock on relation \"%s.%s\" is not available"
slug: aborting-because-lock-on-relation-is-not-available
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17816"
reproduced: false
---

# `aborting because lock on relation "%s.%s" is not available`

## What it means

A maintenance command asked to run without waiting for locks, could not immediately acquire the lock it needed on a relation, and aborted instead of blocking.

## When it happens

It occurs with `VACUUM`, `ANALYZE`, `CLUSTER`, `REINDEX`, or similar commands run with a `nowait`/non-blocking option when another session holds a conflicting lock on the target.

## How to fix

Retry when the conflicting lock is released, or run the command without the non-blocking option so it waits. Identify the blocker by querying `pg_locks` joined to `pg_stat_activity`, and schedule maintenance for a quieter window if contention is frequent.

## Example

*Illustrative* — a non-blocking maintenance command hitting a held lock.

```text
ERROR:  aborting because lock on relation "public.orders" is not available
```

## Related

- [skipping vacuum of --- lock not available](./skipping-vacuum-of-lock-not-available.md)
- [skipping analyze of --- lock not available](./skipping-analyze-of-lock-not-available.md)
