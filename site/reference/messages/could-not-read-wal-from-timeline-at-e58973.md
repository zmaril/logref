---
message: "could not read WAL from timeline %u at %X/%08X: %s"
slug: could-not-read-wal-from-timeline-at-e58973
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack_worker.c:410"
  - "postgres/src/backend/postmaster/walsummarizer.c:1049"
reproduced: false
---

# `could not read WAL from timeline %u at %X/%08X: %s`

## What it means

A server-side WAL reader (the WAL summarizer or a repack worker) could not read WAL from a timeline at a position. The `%u` is the timeline, the `%X/%08X` is the LSN, and the `%s` is the reader's error text.

## When it happens

The needed WAL segment was missing, recycled, or unreadable, or an I/O error occurred, while a background reader scanned WAL for its task.

## How to fix

Read the trailing error. Confirm the required WAL is still present (check `wal_keep_size`, archiving, and slot retention) and that WAL storage is healthy. Missing WAL for a background reader usually means it was recycled too soon.

## Example

*Illustrative* — a WAL segment the summarizer needed was gone.

```text
ERROR:  could not read WAL from timeline 1 at 0/3000000: WAL segment has been removed
```

## Related

- [could not read WAL at](./could-not-read-wal-at-b48b38.md)
- [could not locate backup block with ID in WAL record](./could-not-locate-backup-block-with-id-in-wal-record.md)
