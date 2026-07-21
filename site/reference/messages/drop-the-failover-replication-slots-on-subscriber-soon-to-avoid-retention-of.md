---
message: "Drop the failover replication slots on subscriber soon to avoid retention of WAL files."
slug: drop-the-failover-replication-slots-on-subscriber-soon-to-avoid-retention-of
passthrough: false
api: [pg_log_warning_hint]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1526"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1535"
reproduced: false
---

# `Drop the failover replication slots on subscriber soon to avoid retention of WAL files.`

## What it means

A hint advising that failover replication slots on a subscriber should be dropped soon, because retained slots keep the primary from recycling WAL files.

## When it happens

It accompanies a warning about WAL retention when failover slots on a subscriber are no longer needed but still exist, holding back WAL cleanup.

## Is this a problem?

Drop the named failover slots on the subscriber once you are sure they are no longer needed (for example after a failover completes). Retained slots cause WAL to accumulate on the primary until they are removed.

## Example

*Illustrative* — a hint to drop failover slots.

```text
WARNING:  ...
HINT:  Drop the failover replication slots on subscriber soon to avoid retention of WAL files.
```

## Related

- [Drop this replication slot soon to avoid retention of WAL files.](./drop-this-replication-slot-soon-to-avoid-retention-of-wal-files.md)
- [dropping replication slot "%s"](./dropping-replication-slot.md)
