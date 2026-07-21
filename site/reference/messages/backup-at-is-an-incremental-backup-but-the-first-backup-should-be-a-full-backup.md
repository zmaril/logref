---
message: "backup at \"%s\" is an incremental backup, but the first backup should be a full backup"
slug: backup-at-is-an-incremental-backup-but-the-first-backup-should-be-a-full-backup
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:578"
reproduced: false
---

# `backup at "%s" is an incremental backup, but the first backup should be a full backup`

## What it means

`pg_combinebackup` found that the first backup in the chain is incremental, but the chain must begin with a full backup to reconstruct a complete data directory. The placeholder is the first backup's path.

## When it happens

It occurs when combining backups and the first argument points at an incremental backup rather than the base full backup.

## How to fix

Start the chain with the full backup that the incrementals descend from, then list the incrementals in order. If the full backup is missing, the chain cannot be combined and you must take a new base backup.

## Example

*Illustrative* — an incremental backup in the first slot.

```text
FATAL:  backup at "/backups/wed" is an incremental backup, but the first backup should be a full backup
```

## Related

- [backup at is a full backup but only the first backup should be a full backup](./backup-at-is-a-full-backup-but-only-the-first-backup-should-be-a-full-backup.md)
- [backup manifest version 1 does not support incremental backup](./backup-manifest-version-1-does-not-support-incremental-backup.md)
