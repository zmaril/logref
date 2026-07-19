---
message: "could not synchronize replication slot \"%s\""
slug: could-not-synchronize-replication-slot
passthrough: false
api: [ereport]
level: [LOG]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:287"
  - "postgres/src/backend/replication/logical/slotsync.c:365"
reproduced: false
---

# `could not synchronize replication slot "%s"`

## What it means

A log message that the server could not synchronize a replication slot from the primary to this standby, so the slot's synced state was not advanced.

## When it happens

It arises on a standby with slot synchronization enabled when a slot cannot be synced — for example the primary's slot is not yet in a syncable state, or its required WAL position is not available on the standby.

## Is this a problem?

Often transient: the standby retries as the primary and standby catch up. If it persists, confirm the primary's slot is failover-enabled and active, that the standby is connected, and that WAL retention on the standby covers the slot's needs.

## Example

*Illustrative* — a slot that could not be synced.

```text
LOG:  could not synchronize replication slot "slot1"
```

## Related

- [WAL required by replication slot %s has been removed concurrently](./wal-required-by-replication-slot-has-been-removed-concurrently.md)
- [dropping replication slot "%s"](./dropping-replication-slot.md)
