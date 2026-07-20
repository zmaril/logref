---
message: "could not read WAL from timeline %u at %X/%08X"
slug: could-not-read-wal-from-timeline-at-9a0c21
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/walsummarizer.c:1055"
reproduced: false
---

# `could not read WAL from timeline %u at %X/%08X`

## What it means

The WAL summarizer could not read the write-ahead log on a specific timeline at the given position. The placeholders are the timeline ID and the LSN.

## When it happens

It fires in the background WAL-summarizer process, which walks the log to build the summaries that incremental backups rely on, when the record it needs on that timeline is missing or unreadable.

## How to fix

Make sure the WAL the summarizer needs is still present in `pg_wal` and has not been recycled before summarization caught up. If `wal_summarize` is falling behind, keep more WAL until it catches up, or check the storage for I/O errors. Persistent failures here can leave incremental backups unable to find a base.

## Example

*Illustrative* — the summarizer could not read a timeline's WAL.

```text
ERROR:  could not read WAL from timeline 1 at 0/3000000
```

## Related

- [could not read WAL at LSN](./could-not-read-wal-at-lsn.md)
- [could not read WAL record](./could-not-read-wal-record.md)
