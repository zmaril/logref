---
message: "canceling statement due to conflict with recovery"
slug: canceling-statement-due-to-conflict-with-recovery
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_T_R_DEADLOCK_DETECTED
    code: "40P01"
  - symbol: ERRCODE_T_R_SERIALIZATION_FAILURE
    code: "40001"
call_sites:
  - "postgres/src/backend/storage/ipc/standby.c:921"
  - "postgres/src/backend/tcop/postgres.c:3382"
reproduced: false
---

# `canceling statement due to conflict with recovery`

## What it means

A query running on a hot-standby (read replica) was cancelled because applying incoming WAL from the primary conflicted with it. Replay of the primary's changes cannot wait indefinitely, so a standby query that blocks replay past the configured limit is cancelled.

## When it happens

On a streaming replica, when replay needs to remove rows or take a lock the query depends on — commonly `VACUUM` cleanup on the primary removing tuples a long-running standby query still needs, an exclusive lock from DDL, or a dropped tablespace or database. It scales with how far behind replay is allowed to fall.

## How to fix

For queries that must run long on the standby, raise `max_standby_streaming_delay` (and `max_standby_archive_delay`) to allow replay to wait longer, accepting increased replication lag. Alternatively enable `hot_standby_feedback = on` so the primary holds back cleanup of rows the standby still needs. Retry the cancelled query; it is safe to re-run.

## Example

*Illustrative* — a standby query cancelled by conflicting replay.

```text
ERROR:  canceling statement due to conflict with recovery
DETAIL:  User query might have needed to see row versions that must be removed.
```

## Related

- [cannot make new WAL entries during recovery](./cannot-make-new-wal-entries-during-recovery.md)
- [could not find redo location referenced by checkpoint record at](./could-not-find-redo-location-referenced-by-checkpoint-record-at.md)
