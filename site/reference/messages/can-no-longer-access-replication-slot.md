---
message: "can no longer access replication slot \"%s\""
slug: can-no-longer-access-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/slot.c:732"
reproduced: false
---

# `can no longer access replication slot "%s"`

## What it means

A replication slot that a client or apply process was using has been invalidated and can no longer be read from. The placeholder is the slot name. An invalidated slot has lost the WAL it needs and cannot resume where it left off.

## When it happens

It occurs when a slot is invalidated because required WAL was removed — for example when `max_slot_wal_keep_size` was exceeded — or because of a recovery conflict on a standby.

## How to fix

The slot cannot be revived. Drop and recreate it, then re-establish the consuming client or subscription, which will require re-syncing from a valid position. To prevent recurrence, raise `max_slot_wal_keep_size` or ensure consumers keep up with WAL.

## Example

*Illustrative* — an invalidated slot.

```text
ERROR:  can no longer access replication slot "sub_slot"
```

## Related

- [cannot acquire replication slot](./cannot-acquire-replication-slot.md)
- [cannot advance replication slot to minimum is](./cannot-advance-replication-slot-to-minimum-is.md)
