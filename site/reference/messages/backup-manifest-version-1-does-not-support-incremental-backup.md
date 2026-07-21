---
message: "backup manifest version 1 does not support incremental backup"
slug: backup-manifest-version-1-does-not-support-incremental-backup
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:248"
reproduced: false
---

# `backup manifest version 1 does not support incremental backup`

## What it means

An incremental backup operation encountered a backup manifest written in version 1 format, which predates and cannot describe incremental backups. The manifest version determines which features are available.

## When it happens

It occurs when taking an incremental backup against a base whose manifest is version 1, or when combining backups whose manifest is too old to carry incremental metadata.

## How to fix

Take a fresh full backup with a current server so the manifest is written in a version that supports incremental backups, then build the incremental chain from that base. Incremental backup requires the newer manifest format end to end.

## Example

*Illustrative* — an old manifest blocking an incremental backup.

```text
FATAL:  backup manifest version 1 does not support incremental backup
```

## Related

- [backup at is an incremental backup but the first backup should be a full backup](./backup-at-is-an-incremental-backup-but-the-first-backup-should-be-a-full-backup.md)
- [backup targets are not supported by this server version](./backup-targets-are-not-supported-by-this-server-version.md)
