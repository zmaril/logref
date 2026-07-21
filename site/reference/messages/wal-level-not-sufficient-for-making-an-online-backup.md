---
message: "WAL level not sufficient for making an online backup"
slug: wal-level-not-sufficient-for-making-an-online-backup
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:9471"
  - "postgres/src/backend/access/transam/xlog.c:9801"
reproduced: false
---

# `WAL level not sufficient for making an online backup`

## What it means

An online (base) backup was requested, but the server's `wal_level` is set too low to produce the WAL a consistent backup requires.

## When it happens

It arises from `pg_backup_start()`/`pg_basebackup` when `wal_level` is `minimal`. Online backups need `replica` (or higher) so the WAL records the information needed to restore.

## How to fix

Set `wal_level = replica` (or `logical`) in `postgresql.conf` and restart the server, then retry the backup. `minimal` records too little WAL to support online backup or replication.

## Example

*Illustrative* — attempting a backup at wal_level=minimal.

```text
ERROR:  WAL level not sufficient for making an online backup
```

## Related

- [WAL directory location must be an absolute path](./wal-directory-location-must-be-an-absolute-path.md)
- [WAL required by replication slot %s has been removed concurrently](./wal-required-by-replication-slot-has-been-removed-concurrently.md)
