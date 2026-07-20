---
message: "could not update checksum of base backup"
slug: could-not-update-checksum-of-base-backup
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:1667"
  - "postgres/src/backend/backup/basebackup.c:1786"
  - "postgres/src/backend/backup/basebackup.c:1799"
reproduced: false
---

# `could not update checksum of base backup`

## What it means

Internal error. While producing a base backup, the server could not update the running checksum it computes over the backup's contents (used to build the backup manifest). The placeholder-free message reflects a failure in the checksum computation itself rather than in reading the data.

## When it happens

It does not arise from ordinary use. It points to an internal problem in the base-backup manifest/checksum machinery, possibly tied to the configured checksum algorithm or a library issue, rather than to the database contents.

## How to fix

Treat it as an internal bug. Note the base-backup command and its manifest/checksum options (for example the manifest checksum algorithm) and report it. As a workaround, trying a different manifest checksum setting may sidestep it. Capture a reproducer.

## Example

*Illustrative* — a checksum-update failure during base backup.

```text
ERROR:  could not update checksum of base backup
```

## Related

- [could not send copy-end packet](./could-not-send-copy-end-packet.md)
- [could not find WAL file](./could-not-find-wal-file.md)
