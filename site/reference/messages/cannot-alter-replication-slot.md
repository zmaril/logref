---
message: "cannot alter replication slot \"%s\""
slug: cannot-alter-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/slot.c:969"
reproduced: false
---

# `cannot alter replication slot "%s"`

## What it means

An `ALTER_REPLICATION_SLOT` request could not be applied to the named slot. The placeholder is the slot. The slot is in a state that does not accept the requested change, such as being in use or of a kind that cannot be altered this way.

## When it happens

It occurs when altering a replication slot's properties while it is active, or when the change is not valid for that slot's type.

## How to fix

Ensure the slot is not actively in use and that the property being changed is valid for its type. Stop the consumer holding the slot, check `pg_replication_slots`, then retry the alteration.

## Example

*Illustrative* — altering a slot that will not accept it.

```text
ERROR:  cannot alter replication slot "sub_slot"
```

## Related

- [cannot acquire replication slot](./cannot-acquire-replication-slot.md)
- [cannot advance replication slot to minimum is](./cannot-advance-replication-slot-to-minimum-is.md)
