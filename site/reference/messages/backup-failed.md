---
message: "backup failed: %s"
slug: backup-failed
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2177"
reproduced: false
---

# `backup failed: %s`

## What it means

A base backup could not complete. The placeholder carries the specific reason reported by the backup subsystem. The overall backup operation is abandoned.

## When it happens

It occurs during `pg_basebackup` or a replication-protocol `BASE_BACKUP` when an underlying step fails — a read error, a broken connection, a missing file, or a resource limit.

## How to fix

Read the detail in the placeholder; it names the underlying failure. Address that cause — free disk space, fix connectivity or authentication, check for I/O errors — and rerun the backup. Persistent failures on read may indicate storage problems worth investigating with the server log.

## Example

*Illustrative* — a backup aborting with a reason.

```text
FATAL:  backup failed: could not read file
```

## Related

- [backup is not in progress](./backup-is-not-in-progress.md)
- [background process terminated unexpectedly](./background-process-terminated-unexpectedly.md)
