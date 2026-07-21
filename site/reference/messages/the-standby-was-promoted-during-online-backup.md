---
message: "the standby was promoted during online backup"
slug: the-standby-was-promoted-during-online-backup
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:9840"
  - "postgres/src/backend/backup/basebackup.c:1281"
reproduced: false
---

# `the standby was promoted during online backup`

## What it means

A base backup taken from a standby was invalidated because the standby was promoted to a primary while the backup was in progress. Promotion changes the timeline, so the in-flight backup is no longer consistent.

## When it happens

It arises when a `pg_backup_start`/`pg_backup_stop` (or a base backup) is running against a standby and that standby is promoted before the backup completes.

## How to fix

Do not promote a standby during a backup taken from it. Re-take the backup after the promotion settles (from the new primary or another standby), and coordinate backup and failover operations so they do not overlap.

## Example

*Illustrative* — a standby promoted mid-backup.

```text
ERROR:  the standby was promoted during online backup
HINT:  This means that the backup being taken is corrupt and should not be used.
```

## Related

- [standby promotion is ongoing](./standby-promotion-is-ongoing.md)
- [terminating connection due to conflict with recovery](./terminating-connection-due-to-conflict-with-recovery.md)
