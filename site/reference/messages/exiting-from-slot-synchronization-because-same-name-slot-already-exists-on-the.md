---
message: "exiting from slot synchronization because same name slot \"%s\" already exists on the standby"
slug: exiting-from-slot-synchronization-because-same-name-slot-already-exists-on-the
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:763"
reproduced: false
---

# `exiting from slot synchronization because same name slot "%s" already exists on the standby`

## What it means

A standby's slot-synchronization worker stopped because a replication slot it needs to create already exists on the standby under the same name but was not created by slot sync. The placeholder is the slot name.

## When it happens

It fires on a hot standby with slot synchronization enabled when a manually created (or otherwise pre-existing) slot collides with a slot the standby is trying to mirror from the primary. Slot sync refuses to take over a slot it did not create.

## How to fix

Decide which slot should own the name. If the pre-existing slot on the standby is not needed, drop it with `pg_drop_replication_slot()` so synchronization can recreate it as a synced slot. If it is needed, rename or remove the conflicting synced slot on the primary. Do not manually create slots whose names collide with synchronized ones.

## Example

*Illustrative* — the message as logged.

```
ERROR:  exiting from slot synchronization because same name slot "sub_slot" already exists on the standby
```

## Related

- [error while shutting down streaming COPY](./error-while-shutting-down-streaming-copy.md)
- [expected 0 logical replication slots but found](./expected-0-logical-replication-slots-but-found.md)
