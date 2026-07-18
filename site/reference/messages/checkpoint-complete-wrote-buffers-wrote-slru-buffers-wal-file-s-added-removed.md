---
message: "checkpoint complete:%s: wrote %d buffers (%.1f%%), wrote %d SLRU buffers; %d WAL file(s) added, %d removed, %d recycled; write=%ld.%03d s, sync=%ld.%03d s, total=%ld.%03d s; sync files=%d, longest=%ld.%03d s, average=%ld.%03d s; distance=%d kB, estimate=%d kB; lsn=%X/%08X, redo lsn=%X/%08X"
slug: checkpoint-complete-wrote-buffers-wrote-slru-buffers-wal-file-s-added-removed
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:7264"
reproduced: false
---

# `checkpoint complete:%s: wrote %d buffers (%.1f%%), wrote %d SLRU buffers; %d WAL file(s) added, %d removed, %d recycled; write=%ld.%03d s, sync=%ld.%03d s, total=%ld.%03d s; sync files=%d, longest=%ld.%03d s, average=%ld.%03d s; distance=%d kB, estimate=%d kB; lsn=%X/%08X, redo lsn=%X/%08X`

**Severity:** LOG

## What it means

A checkpoint has finished, with a detailed accounting of the work it did. The fields report how many buffers were written, how long the write and `fsync` phases took, how many WAL files were added/removed/recycled, the I/O distance covered, and the resulting WAL positions. It is the companion to the `checkpoint starting` line and is purely informational `LOG`.

## When it happens

Logged at the end of every checkpoint when `log_checkpoints` is on. The `write` time is spread out deliberately (paced by `checkpoint_completion_target`) to avoid an I/O spike, so a long `write` phase is expected; a long `sync` phase is the part that signals disk pressure.

## Is this a problem?

No action needed for a healthy system. Use the numbers for tuning: a large buffer count or short interval between checkpoints suggests raising `max_wal_size`; a long `sync` time points at storage that struggles to flush. The `distance` and `estimate` fields track how much WAL each checkpoint spans, which helps size `max_wal_size`. This line is a primary input to checkpoint tuning.

## Source

Emitted from [`postgres/src/backend/access/transam/xlog.c:7264`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlog.c#L7264).

## Related

- [checkpoint starting](./checkpoint-starting.md)
- [database system is ready to accept connections](./database-system-is-ready-to-accept-connections.md)
