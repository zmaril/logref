---
message: "recovery is in progress"
slug: recovery-is-in-progress
passthrough: false
api: [ereport]
level: [ERROR, WARNING]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/pg_surgery/heap_surgery.c:98"
  - "postgres/src/backend/access/brin/brin.c:1400"
  - "postgres/src/backend/access/brin/brin.c:1507"
  - "postgres/src/backend/access/gin/ginfast.c:1038"
  - "postgres/src/backend/access/transam/xlogfuncs.c:212"
  - "postgres/src/backend/access/transam/xlogfuncs.c:237"
  - "postgres/src/backend/access/transam/xlogfuncs.c:270"
  - "postgres/src/backend/access/transam/xlogfuncs.c:309"
  - "postgres/src/backend/access/transam/xlogfuncs.c:330"
  - "postgres/src/backend/access/transam/xlogfuncs.c:351"
  - "postgres/src/backend/access/transam/xlogfuncs.c:417"
  - "postgres/src/backend/access/transam/xlogfuncs.c:476"
  - "postgres/src/backend/commands/wait.c:190"
  - "postgres/src/backend/statistics/attribute_stats.c:178"
  - "postgres/src/backend/statistics/attribute_stats.c:618"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:368"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1776"
  - "postgres/src/backend/statistics/relation_stats.c:95"
reproduced: false
---

# `recovery is in progress`

## What it means

An operation was rejected because the server is in recovery (a standby, or a primary still replaying WAL during startup). While in recovery the database is read-only, so functions and statements that would modify state — or that only make sense on a primary — are refused.

## When it happens

Calling a write or control function on a hot standby: `pg_switch_wal()`, `nextval()` on a sequence, `ANALYZE`/statistics writes, or any data modification. It also appears briefly on a primary that is still finishing crash or archive recovery at startup.

## How to fix

If this is a standby, run the operation on the primary instead — the standby cannot perform writes by design. If it is a primary that is still starting, wait for recovery to finish (watch for "database system is ready to accept connections"). Use `pg_is_in_recovery()` to check state programmatically before attempting a write-only operation.

## Example

*Illustrative* — a write function called on a standby.

```sql
SELECT pg_switch_wal();
```

Produces:

```text
ERROR:  recovery is in progress
HINT:  WAL control functions cannot be executed during recovery.
```

## Related

- [recovery is not in progress](./recovery-is-not-in-progress.md)
- [cannot execute %s during recovery](./cannot-execute-on-relation.md)
