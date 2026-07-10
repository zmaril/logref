---
message: "checkpoint starting:%s"
slug: checkpoint-starting
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:7180"
reproduced: true
---

# `checkpoint starting:%s`

**Severity:** LOG

## What it means

A checkpoint has begun. A checkpoint flushes dirty shared-buffer pages to disk and records a WAL position from which crash recovery can start, bounding how much WAL must be replayed after a crash. The placeholder lists the reasons the checkpoint was triggered, such as `time`, `wal`, `immediate`, or `force`. This is a normal, informational `LOG` line.

## When it happens

Emitted whenever a checkpoint starts (visible when `log_checkpoints` is on, the default on modern versions): on the `checkpoint_timeout` schedule, when WAL volume crosses `max_wal_size`, at a manual `CHECKPOINT` command, and around operations like `pg_basebackup` or a clean shutdown.

## Is this a problem?

Nothing to fix — this is routine bookkeeping. Watch it only for tuning: if the reason is frequently `wal` (rather than `time`), checkpoints are being forced by WAL volume and raising `max_wal_size` can space them out. Frequent checkpoints increase write amplification, so the interval between `starting` lines is a useful health signal. Pair this with the matching `checkpoint complete` line for timing.

## Example

*Reproduced* — The setup reproducer scenario issues an explicit `CHECKPOINT` (`00_setup.sql`).

```sql
CHECKPOINT;
```

Produces:

```text
LOG:  checkpoint starting: immediate force wait
```

## Source

Emitted from [`postgres/src/backend/access/transam/xlog.c:7180`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlog.c#L7180).

## Related

- [checkpoint complete](./checkpoint-complete-wrote-buffers-wrote-slru-buffers-wal-file-s-added-removed.md)
- [database system is ready to accept connections](./database-system-is-ready-to-accept-connections.md)
