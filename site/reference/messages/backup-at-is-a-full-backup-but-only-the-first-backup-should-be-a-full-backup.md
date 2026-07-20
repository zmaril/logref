---
message: "backup at \"%s\" is a full backup, but only the first backup should be a full backup"
slug: backup-at-is-a-full-backup-but-only-the-first-backup-should-be-a-full-backup
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:575"
reproduced: false
---

# `backup at "%s" is a full backup, but only the first backup should be a full backup`

## What it means

`pg_combinebackup` was given a chain of backups in which a backup after the first is a full backup, but only the first entry in the chain may be full; the rest must be incremental. The placeholder is the offending backup's path.

## When it happens

It occurs when combining an incremental backup chain and the backups are listed out of order, or a full backup is passed where an incremental one was expected.

## How to fix

Order the arguments as one full backup followed by the incremental backups that build on it, in sequence. Do not include a second full backup in the chain; reconstruct the intended chain from the backup manifests.

## Example

*Illustrative* — a full backup in a later slot.

```text
FATAL:  backup at "/backups/tue" is a full backup, but only the first backup should be a full backup
```

## Related

- [backup at is an incremental backup but the first backup should be a full backup](./backup-at-is-an-incremental-backup-but-the-first-backup-should-be-a-full-backup.md)
- [backup at starts at lsn but expected](./backup-at-starts-at-lsn-but-expected.md)
