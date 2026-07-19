---
message: "backup is not in progress"
slug: backup-is-not-in-progress
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlogfuncs.c:169"
reproduced: false
---

# `backup is not in progress`

## What it means

A function that ends or manipulates an in-progress backup was called when no backup is currently running in the session. The stop step has nothing to finish.

## When it happens

It occurs when `pg_backup_stop()` is called without a matching `pg_backup_start()`, when the start ran in a different session, or when the backup already ended.

## How to fix

Call the start function first and run the stop in the same session that started the backup. The non-exclusive backup API keeps the backup state tied to the session, so start and stop must be paired within one connection.

## Example

*Illustrative* — stopping a backup that never started.

```text
ERROR:  backup is not in progress
```

## Related

- [backup failed](./backup-failed.md)
- [backup label buffer too small](./backup-label-buffer-too-small.md)
