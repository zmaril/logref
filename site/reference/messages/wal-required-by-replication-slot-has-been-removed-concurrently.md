---
message: "WAL required by replication slot %s has been removed concurrently"
slug: wal-required-by-replication-slot-has-been-removed-concurrently
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:667"
  - "postgres/src/backend/replication/slot.c:1765"
reproduced: false
---

# `WAL required by replication slot %s has been removed concurrently`

## What it means

A consumer of a replication slot needed a WAL position that has already been removed, because the slot's required WAL was recycled while it was in use.

## When it happens

It arises when a slot falls far enough behind (or `max_slot_wal_keep_size` caps retention) that the WAL it still needs is removed, and a reader then requests that now-missing position.

## How to fix

The slot's consumer must be re-seeded or recreated, since the WAL it needed is gone. Prevent recurrence by keeping consumers current and by sizing `max_slot_wal_keep_size` (or disk) so needed WAL is retained.

## Example

*Illustrative* — a slot's WAL removed while in use.

```text
ERROR:  WAL required by replication slot slot1 has been removed concurrently
```

## Related

- [unexpected EOF on standby connection](./unexpected-eof-on-standby-connection.md)
- [WAL level not sufficient for making an online backup](./wal-level-not-sufficient-for-making-an-online-backup.md)
