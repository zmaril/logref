---
message: "could not initiate base backup: %s"
slug: could-not-initiate-base-backup
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2004"
reproduced: false
---

# `could not initiate base backup: %s`

## What it means

`pg_basebackup` sent the command to start a base backup and the server refused or errored before the backup began. The `%s` value carries the server's reason. Nothing is copied when the backup cannot start.

## When it happens

It happens at the start of a base backup, when the server rejects the `BASE_BACKUP` request — often too few WAL sender slots, missing replication privileges, or an incompatible server configuration.

## How to fix

Read the included server reason. Common causes are `max_wal_senders` set too low, the connecting role lacking `REPLICATION` (or the right role membership), and `pg_hba.conf` not allowing a replication connection. Fix the setting or permission and rerun.

## Example

*Illustrative* — the server refused to start the backup.

```text
pg_basebackup: fatal: could not initiate base backup: ERROR:  number of requested standby connections exceeds max_wal_senders
```

## Related

- [could not get backup header](./could-not-get-backup-header.md)
- [could not get COPY data stream](./could-not-get-copy-data-stream.md)
