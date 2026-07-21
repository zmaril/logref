---
message: "Drop this replication slot soon to avoid retention of WAL files."
slug: drop-this-replication-slot-soon-to-avoid-retention-of-wal-files
passthrough: false
api: [pg_log_warning_hint]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:272"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1492"
reproduced: false
---

# `Drop this replication slot soon to avoid retention of WAL files.`

## What it means

A hint advising that a replication slot should be dropped soon, because an unused slot keeps the server from recycling WAL files.

## When it happens

It accompanies a warning about a slot that is inactive or no longer needed but still retains WAL, causing `pg_wal` to grow.

## Is this a problem?

Drop the slot with `pg_drop_replication_slot()` once it is no longer needed. An unused slot pins WAL indefinitely; removing it lets the server recycle the retained segments and reclaim disk.

## Example

*Illustrative* — a hint to drop an unused slot.

```text
WARNING:  ...
HINT:  Drop this replication slot soon to avoid retention of WAL files.
```

## Related

- [Drop the failover replication slots on subscriber soon to avoid retention of WAL files.](./drop-the-failover-replication-slots-on-subscriber-soon-to-avoid-retention-of.md)
- [WAL required by replication slot %s has been removed concurrently](./wal-required-by-replication-slot-has-been-removed-concurrently.md)
