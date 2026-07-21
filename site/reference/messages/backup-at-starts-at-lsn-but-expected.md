---
message: "backup at \"%s\" starts at LSN %X/%08X, but expected %X/%08X"
slug: backup-at-starts-at-lsn-but-expected
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:584"
reproduced: false
---

# `backup at "%s" starts at LSN %X/%08X, but expected %X/%08X`

## What it means

`pg_combinebackup` found that an incremental backup begins at a write-ahead log position that does not match the end of the previous backup in the chain. The placeholders are the actual and expected LSNs. A chain must be continuous in the WAL stream.

## When it happens

It occurs when combining backups whose LSNs do not line up, meaning the incrementals were not taken as a consecutive chain, or one is missing.

## How to fix

Rebuild the chain from backups whose start and end LSNs are contiguous, using the backup manifests to order them. A gap means an intermediate backup is missing or a backup from a different chain was included.

## Example

*Illustrative* — a discontinuous LSN in the chain.

```text
FATAL:  backup at "/backups/inc2" starts at LSN 0/9000000, but expected 0/8A00000
```

## Related

- [backup at starts on timeline but expected](./backup-at-starts-on-timeline-but-expected.md)
- [backup at is a full backup but only the first backup should be a full backup](./backup-at-is-a-full-backup-but-only-the-first-backup-should-be-a-full-backup.md)
