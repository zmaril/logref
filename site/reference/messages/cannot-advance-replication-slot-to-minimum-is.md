---
message: "cannot advance replication slot to %X/%08X, minimum is %X/%08X"
slug: cannot-advance-replication-slot-to-minimum-is
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/slotfuncs.c:592"
reproduced: false
---

# `cannot advance replication slot to %X/%08X, minimum is %X/%08X`

## What it means

A request to advance a replication slot named a position at or behind where the slot already is. The placeholders are the requested position and the current minimum. A slot can only move forward in the WAL.

## When it happens

It occurs when `pg_replication_slot_advance()` is given a target LSN that is not ahead of the slot's current confirmed position.

## How to fix

Advance the slot to a position ahead of its current one. Read the slot's current LSN from `pg_replication_slots` and choose a target beyond it; a slot cannot be rewound to an earlier position.

## Example

*Illustrative* — advancing a slot backward.

```text
ERROR:  cannot advance replication slot to 0/1000000, minimum is 0/2000000
```

## Related

- [cannot acquire replication slot](./cannot-acquire-replication-slot.md)
- [can no longer access replication slot](./can-no-longer-access-replication-slot.md)
