---
message: "replication slot \"%s\" is active for PID %d"
slug: replication-slot-is-active-for-pid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/replication/slot.c:715"
  - "postgres/src/backend/replication/slot.c:1590"
reproduced: true
---

# `replication slot "%s" is active for PID %d`

## What it means

An operation tried to use or drop a replication slot that another process currently has acquired. The placeholders are the slot name and the PID using it. A slot can be actively held by only one process at a time.

## When it happens

It arises when starting replication from a slot already in use, dropping a slot with an active consumer, or two consumers contending for the same slot.

## How to fix

Wait for the current holder (the reported PID) to release the slot, or stop that consumer. To drop the slot, first disconnect its consumer. Give each replication consumer its own slot to avoid contention.

## Example

*Reproduced* — this site fired under `reproducers/scenarios/59_repl_slots.sh`; see the reproducer for the triggering workload. It emits:

```text
ERROR:  replication slot "%s" is active for PID %d
```

## Related

- [replication origin with ID %d is already active for PID %d](./replication-origin-with-id-is-already-active-for-pid.md)
- [replication slot "%s" was not created in this database](./replication-slot-was-not-created-in-this-database.md)
