---
message: "a backup is already in progress in this session"
slug: a-backup-is-already-in-progress-in-this-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlogfuncs.c:98"
  - "postgres/src/backend/backup/basebackup.c:997"
reproduced: false
---

# `a backup is already in progress in this session`

## What it means

A backup-control function was called while the same session already had a backup running. A session may run only one in-progress base backup at a time through these functions, so a second start is rejected.

## When it happens

Calling `pg_backup_start` twice in one session without an intervening `pg_backup_stop`, or invoking a base-backup routine while this session's earlier backup is still active.

## How to fix

Finish the current backup with `pg_backup_stop` before starting another, or use a separate session for a concurrent backup. Check for an earlier start that was never stopped, for example because an error skipped the stop call.

## Example

*Illustrative* — starting a second backup in one session.

```sql
SELECT pg_backup_start('b2');  -- a backup is already in progress in this session
```

## Related

- [backup is not in progress](./backup-is-not-in-progress.md)
- [a backup is already in progress in this session](./a-backup-is-already-in-progress-in-this-session.md)
