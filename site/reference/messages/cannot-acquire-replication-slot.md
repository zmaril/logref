---
message: "cannot acquire replication slot \"%s\""
slug: cannot-acquire-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/replication/slot.c:660"
reproduced: false
---

# `cannot acquire replication slot "%s"`

## What it means

A process could not acquire a replication slot because it is already held by another backend, or is otherwise unavailable. The placeholder is the slot name. A slot may be used by only one consumer at a time.

## When it happens

It occurs when a walsender or apply worker tries to start using a slot that another session already holds, for example two consumers pointed at the same slot.

## How to fix

Ensure only one consumer uses the slot at a time. Find and stop the process currently holding it, check `pg_replication_slots` for the active session, and give each consumer its own slot.

## Example

*Illustrative* — a slot already in use.

```text
ERROR:  cannot acquire replication slot "sub_slot"
```

## Related

- [can no longer access replication slot](./can-no-longer-access-replication-slot.md)
- [cannot advance replication slot to minimum is](./cannot-advance-replication-slot-to-minimum-is.md)
