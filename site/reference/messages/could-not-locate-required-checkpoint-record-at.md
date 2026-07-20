---
message: "could not locate required checkpoint record at %X/%08X"
slug: could-not-locate-required-checkpoint-record-at
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:604"
reproduced: false
---

# `could not locate required checkpoint record at %X/%08X`

## What it means

During recovery the server tried to read the checkpoint record that recovery must start from and could not find it at the expected WAL location. Recovery begins by reading this record to learn where to replay from.

## When it happens

It fires at startup while entering crash or archive recovery, when the checkpoint record named by the control file or backup label is missing or unreadable — usually a truncated, removed, or corrupt WAL segment, or a missing `backup_label`.

## How to fix

Do not initialize or reset WAL blindly, since that risks data loss. Make sure every WAL segment recovery needs is present (restore missing ones from the archive), and that a base backup's `backup_label` is in place. If the required WAL is genuinely gone, recover from a known-good backup. Resetting WAL is a last resort that can corrupt data.

## Example

*Illustrative* — the starting checkpoint record could not be read.

```text
FATAL:  could not locate required checkpoint record at 0/16D8A20
```

## Related

- [could not find WAL buffer for](./could-not-find-wal-buffer-for.md)
- [could not find WAL in archive](./could-not-find-wal-in-archive-1ea321.md)
