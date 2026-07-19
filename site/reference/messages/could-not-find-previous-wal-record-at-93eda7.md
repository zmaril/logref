---
message: "could not find previous WAL record at %X/%08X: %s"
slug: could-not-find-previous-wal-record-at-93eda7
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/parsexlog.c:214"
reproduced: false
---

# `could not find previous WAL record at %X/%08X: %s`

## What it means

`pg_rewind` could not read the WAL record immediately before a target position while walking the WAL backward. The `%X/%08X` is the LSN and `%s` gives extra detail. Without the previous record it cannot trace the history it needs.

## When it happens

It happens during a `pg_rewind` run when a required WAL record before the divergence point is missing or unreadable — for example WAL was recycled, removed, or damaged before the rewind could read it.

## How to fix

Make sure the source cluster still has intact WAL covering the divergence point (adjust retention or restore archived segments). The detail names the underlying read problem; resolve it and rerun.

## Example

*Illustrative* — a missing prior WAL record during rewind.

```text
pg_rewind: fatal: could not find previous WAL record at 0/1A00060: invalid record length
```

## Related

- [could not find previous WAL record at](./could-not-find-previous-wal-record-at-2cf954.md)
- [could not fetch remote file](./could-not-fetch-remote-file.md)
