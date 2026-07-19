---
message: "could not find previous WAL record at %X/%08X"
slug: could-not-find-previous-wal-record-at-2cf954
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/parsexlog.c:218"
reproduced: false
---

# `could not find previous WAL record at %X/%08X`

## What it means

`pg_rewind` could not read the WAL record immediately before a target position while walking the WAL backward. The `%X/%08X` is the LSN. Without the previous record it cannot trace the history it needs.

## When it happens

It happens during a `pg_rewind` run when a required WAL record before the divergence point is missing — for example WAL was recycled or removed before the rewind could read it.

## How to fix

Make sure the source cluster still has the WAL covering the divergence point (adjust WAL retention or restore archived segments). `pg_rewind` needs continuous WAL back to the common ancestor; rerun once it is available.

## Example

*Illustrative* — a missing prior WAL record during rewind.

```text
pg_rewind: fatal: could not find previous WAL record at 0/1A00060
```

## Related

- [could not find previous WAL record at (with detail)](./could-not-find-previous-wal-record-at-93eda7.md)
- [could not find common ancestor of the source and target cluster's timelines](./could-not-find-common-ancestor-of-the-source-and-target-cluster-s-timelines.md)
